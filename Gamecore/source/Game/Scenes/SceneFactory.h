#pragma once

#include "../../Lua/LuaManager.h"
#include "../Director.h"

#include "GameScene.h"
#include "BootState.h"
#include "TestScene.h"
#include "Entity.h"
#include <map>
#include <string>
#include <memory>
#include <iostream>

class SceneFactory
{
    lua_State* LuaContext = nullptr;

    std::string StartSceneID;
    std::string SharedSceneID;

public:
    SceneFactory() : LuaContext(LuaManager::Get().GetState()) {}

    GETTERSETTER(const std::string&, StartSceneID, StartSceneID)
    GETTERSETTER(const std::string&, SharedSceneID, SharedSceneID)

    // ================================================================
    // Loads all scenes from scenes.lua
    // ================================================================
    std::map<std::string, GameScene*> LoadAllScenes(const std::string& path)
    {
        std::map<std::string, GameScene*> scenes;

        if (luaL_dofile(LuaContext, LuaManager::Get().AddDebugRootPath(path).c_str()) != LUA_OK)
        {
            std::cout << "Lua error loading " << path << ": " << lua_tostring(LuaContext, -1) << std::endl;
            lua_pop(LuaContext, 1);
            return scenes;
        }

        lua_getglobal(LuaContext, "Scenes");
        if (!lua_istable(LuaContext, -1))
        {
            std::cout << "[SceneFactory] Scenes.lua did not return a table.\n";
            lua_pop(LuaContext, 1);
            return scenes;
        }

        int absScenesIndex = lua_absindex(LuaContext, -1);
        lua_pushnil(LuaContext);

        while (lua_next(LuaContext, absScenesIndex) != 0)
        {
            GameScene* scene = nullptr;
            std::string sceneName;

            int keyType = lua_type(LuaContext, -2);
            int valType = lua_type(LuaContext, -1);

            if (keyType == LUA_TSTRING)
            {
                sceneName = lua_tostring(LuaContext, -2);

                if (valType == LUA_TTABLE)
                {
                    /// Case 1: Named scene, e.g. Boot = { ... }
                    int absSceneIndex = lua_absindex(LuaContext, -1);
                    scene = CreateSceneFromLua(sceneName, absSceneIndex);
                }
                else    
                {
                    /// Case 2A: special string values: StartScene, SharedScene
                    if (valType == LUA_TSTRING)
                    {
                        std::string sceneSetup = lua_tostring(LuaContext, -1);

                        if (sceneName == "StartScene")
                            StartSceneID = sceneSetup;

                        if (sceneName == "SharedScene")
                            SharedSceneID = sceneSetup;

                        lua_pop(LuaContext, 1); // pop value
                        continue;
                    }

                    /// Case 2B: boolean values: Title = true, Intro = false // ignore if false
                    if (valType == LUA_TBOOLEAN && !lua_toboolean(LuaContext, -1))
                    {
                        lua_pop(LuaContext, 1); // pop value
                        continue;
                    }

                    scene = CreateSceneFromLua(sceneName, LUA_NOREF);
                }
            }
            else if (keyType == LUA_TNUMBER && valType == LUA_TSTRING)
            {
                /// Case 3: Array-style scene list: "Title", "Intro"
                sceneName = lua_tostring(LuaContext, -1);
                scene = CreateSceneFromLua(sceneName, LUA_NOREF);
            }
            else
            {
                std::cout << "[SceneFactory] Skipping malformed entry ("
                    << lua_typename(LuaContext, keyType) << " -> "
                    << lua_typename(LuaContext, valType) << ").\n";
            }

            if (scene && !sceneName.empty())
            {
                std::cout << "Created Scene: " << sceneName << " succesfully!" << std::endl;
                scenes[sceneName] = scene;
            }

            lua_pop(LuaContext, 1); // pop value
        }

        lua_pop(LuaContext, 1); // pop Scenes
        return scenes;
    }


private:
    // ================================================================
    // Create a scene (specialized or fallback)
    // ================================================================
    GameScene* CreateSceneFromLua(const std::string& name, int tableIndex)
    {
        GameScene* scene = nullptr;

        /// --- Hardcoded special scene types ---
        if (name == "Boot")
            scene = new BootState();
        else if (name == "Test")
            scene = new TestScene();
        // else if (name == "Credits") scene = new CreditScene();
        // else if (name == "Intro")   scene = new IntroScene();

        /// --- Otherwise fallback ---
        if (!scene)
            scene = new GameScene();

        if (tableIndex == LUA_NOREF) // (empty entry like Intro = nil), skip parsing
            return scene;

        // Iterate entities
        lua_pushnil(LuaContext);
        while (lua_next(LuaContext, tableIndex) != 0)
        {
            if (lua_istable(LuaContext, -1))
                if (Entity* entity = CreateEntityFromLua(-1))
                    scene->Entities.push_back(entity);

            lua_pop(LuaContext, 1); // pop value, keep key
        }

        return scene;
    }

    // ================================================================
    // Create entity based on table key (supports arbitrary keys)
    // ================================================================
    Entity* CreateEntityFromLua(int tableIndex)
    {
        if (!lua_istable(LuaContext, tableIndex))
            return nullptr;

        int absIndex = lua_absindex(LuaContext, tableIndex);

        Entity* entity = nullptr;

        lua_pushnil(LuaContext);               // Iterate all key/value pairs

        while (lua_next(LuaContext, absIndex) != 0)
        {
            if (lua_isstring(LuaContext, -2) && lua_isstring(LuaContext, -1))
            {
                std::string key = lua_tostring(LuaContext, -2);
                std::string scriptPath = lua_tostring(LuaContext, -1);

                entity = Director::Get().CreateEntity( key, scriptPath);

                lua_pop(LuaContext, 1); // pop value (keep key)
                break; // only take first key/value per entity table
            }

            lua_pop(LuaContext, 1); // pop value
        }

        lua_pop(LuaContext, 1); // pop last key
        return entity;
    }
};

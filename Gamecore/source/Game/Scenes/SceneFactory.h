#pragma once

#include "../../Lua/LuaManager.h"
#include "../Director.h"
#include "../Assets.h"

#include "Entity.h"
#include "GameScene.h"
#include "BootState.h"
#include "TestScene.h"
#include "AnimeScene.h"

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
        else if (name == "Road")
            scene = new AnimeScene(&Assets::Get().NightDriveIntro(), []() { Assets::Get().PreloadRoadIntroAnimation(); });
        else if (name == "Intro")
            scene = new AnimeScene(&Assets::Get().MansionIntro(), []() { Assets::Get().PreloadMansionIntroAnimation(); });

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
            {
                //std::string sceneScript = FindScriptEntry(-1);
                //if (!sceneScript.empty())
                //    scene->LoadScript(sceneScript);

                if (Entity* entity = CreateEntityFromLua(-1))
                    scene->Entities.push_back(entity);
            }

            lua_pop(LuaContext, 1); // pop value, keep key
        }

        return scene;
    }

    // ================================================================
    // Search for a scene script on table key (can be optional)
    // ================================================================
    /*
    const std::string FindScriptEntry(int tableIndex)
    {
        if (!lua_istable(LuaContext, tableIndex))
            return {};

        int absIndex = lua_absindex(LuaContext, tableIndex);
        std::string scriptPath;

        lua_pushnil(LuaContext);
        while (lua_next(LuaContext, absIndex) != 0)
        {
            if (lua_isstring(LuaContext, -2) && lua_isstring(LuaContext, -1))
            {
                std::string key = lua_tostring(LuaContext, -2);
                if (key == "Script" || key == "script")
                {
                    scriptPath = lua_tostring(LuaContext, -1);
                    lua_pop(LuaContext, 1);                     // pop value, keep key
                    break;                                      // found, no need to continue
                }
            }
            lua_pop(LuaContext, 1);                             // pop value, continue iteration
        }

        return scriptPath;
    }
    */

    // ================================================================
    // Create entity based on table key (supports arbitrary keys)
    // ================================================================
    Entity* CreateEntityFromLua(int tableIndex)
    {
        if (!lua_istable(LuaContext, tableIndex))
            return nullptr;

        int absIndex = lua_absindex(LuaContext, tableIndex);
        Entity* entity = nullptr;

        // First: check if this table has a field named "Entity"
        lua_getfield(LuaContext, absIndex, "Entity");
        bool isInlineEntity = lua_isstring(LuaContext, -1);
        lua_pop(LuaContext, 1);

        if (isInlineEntity)
        {
            // Inline format { Entity = "Dark", ... }
            SpriteInfo data = SpriteFromLua(LuaContext, absIndex);
            entity = Director::Get().CreateEntity(data);
            return entity;
        }

        // Otherwise, treat and iterate as standard key-script pair
        lua_pushnil(LuaContext);                                

        while (lua_next(LuaContext, absIndex) != 0)
        {
            if (lua_isstring(LuaContext, -2))  // key
            {
                std::string key = lua_tostring(LuaContext, -2);

                // Case 1: value is a string > external script path
                if (lua_isstring(LuaContext, -1))
                {
                    std::string scriptPath = lua_tostring(LuaContext, -1);

                    //if (key != "Script" || key != "script")
                    entity = Director::Get().CreateEntity(key, scriptPath);
                }

                // Case 2: value is a table >  embedded inline script
                else if (lua_istable(LuaContext, -1))
                {
                    // Create entity with inline table reference
                    entity = Director::Get().CreateEntityInline(key, lua_absindex(LuaContext, -1));
                }

                lua_pop(LuaContext, 1);                         // pop value (keep key)
                break;                                          // only take first key/value per entity table
            }

            lua_pop(LuaContext, 1);                             // pop value
        }

        lua_pop(LuaContext, 1);                                 // pop last key
        return entity;
    }

    SpriteInfo SpriteFromLua(lua_State* L, int tableIndex)
    {
        SpriteInfo data;
        data.Clickable = false;

        const int abs = lua_absindex(L, tableIndex);
        std::string currentID;

        // Helper: load flat { id = "path", ... } at abs table index
        auto loadFlat = [&](int tAbs) {
            lua_pushnil(L);
            while (lua_next(L, tAbs) != 0)
            {
                if (lua_isstring(L, -2) && lua_isstring(L, -1))
                {
                    std::string id = lua_tostring(L, -2);
                    std::string path = lua_tostring(L, -1);
                    Assets::Get().LoadTextureID(id, path);
                    data.TexturesIDs.push_back(id);
                }
                lua_pop(L, 1); // pop value, keep key
            }
        };

        lua_pushnil(L);
        while (lua_next(L, abs) != 0)                // key at -2, value at -1
        {
            if (lua_isstring(L, -2))
            {
                std::string key = lua_tostring(L, -2);

                if (key == "Entity" && lua_isstring(L, -1))
                    data.NameId = lua_tostring(L, -1);

                else if (key == "Alpha" && lua_isnumber(L, -1))
                    data.Alpha = (float)lua_tonumber(L, -1);

                else if (key == "Visible" && lua_isboolean(L, -1))
                    data.Visible = lua_toboolean(L, -1);

                else if (key == "Active" && lua_isboolean(L, -1))
                    data.Active = lua_toboolean(L, -1);

                else if (key == "Clickable" && lua_isboolean(L, -1))
                    data.Clickable = lua_toboolean(L, -1);

                else if (key == "Position" && lua_istable(L, -1))
                {
                    lua_getfield(L, -1, "x");
                    if (lua_isnumber(L, -1)) data.PositionX = (int)lua_tonumber(L, -1);
                    lua_pop(L, 1);

                    lua_getfield(L, -1, "y");
                    if (lua_isnumber(L, -1)) data.PositionY = (int)lua_tonumber(L, -1);
                    lua_pop(L, 1);
                }
                else if (key == "CurrentImage" && lua_isstring(L, -1))
                    currentID = lua_tostring(L, -1);

                else if (key == "Textures")
                {
                    // --- Case A: Textures = "path.png"  (lazy form) ---
                    if (lua_isstring(L, -1))
                    {
                        std::string path = lua_tostring(L, -1);

                        // fallback ID = entity NameId if exists, else use path
                        std::string texId = data.NameId.empty() ? path : data.NameId;

                        Assets::Get().LoadTextureID(texId, path);
                        data.TexturesIDs.push_back(texId);
                    }

                    // --- Case B: Textures = { ... } table ---
                    else if (lua_istable(L, -1))
                    {
                        const int texAbs = lua_absindex(L, -1);

                        // detect flat vs nested
                        bool flat = false;
                        lua_pushnil(L);
                        if (lua_next(L, texAbs) != 0)
                        {
                            flat = (lua_isstring(L, -2) && lua_isstring(L, -1));
                            lua_pop(L, 1); // value
                            lua_pop(L, 1); // key
                        }

                        if (flat)
                            loadFlat(texAbs);
                        else
                        {
                            lua_pushnil(L);
                            while (lua_next(L, texAbs) != 0)
                            {
                                if (lua_istable(L, -1))
                                    loadFlat(lua_absindex(L, -1));
                                lua_pop(L, 1);
                            }
                        }
                    }
                }

            }

            lua_pop(L, 1); // pop value, keep key for next lua_next
        }

        // Honor CurrentImage by moving it to the front (if present)
        if (!currentID.empty())
            if (Assets::Get().HasTextureID(currentID))
            {
                if (data.TexturesIDs.empty()) 
                    data.TexturesIDs.push_back(currentID);
                else
                {
                    auto it = std::find(data.TexturesIDs.begin(), data.TexturesIDs.end(), currentID);
                    if (it != data.TexturesIDs.end() && it != data.TexturesIDs.begin()) 
                        std::rotate(data.TexturesIDs.begin(), it, it + 1);
                }
            }
            else
                std::cout << "\n [ERROR] not found CurrentTextureID: " << currentID << std::endl << std::endl;


        return data;
    }

};

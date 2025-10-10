#include "LuaFunctions.h"

#include "LuaManager.h"
#include "../Game/Assets.h"
#include "../Game/Director.h"
#include "../Game/Game.h"
#include "../Game/Scenes/Entity.h"
#include "../Game/Scenes/FSM.h"

#include <raylib-cpp.hpp>

// Helper for stack trace
int traceback(lua_State* L) 
{
    const char* msg = lua_tostring(L, 1);
    if (msg)
        luaL_traceback(L, L, msg, 1);
    else
        lua_pushliteral(L, "(no error message)");
    return 1;
}

// Example native functions
int Lua_Say(lua_State* L)
{
    const std::string& msg = luaL_checkstring(L, 1);

    lua_newtable(L);                       // create table
    lua_pushstring(L, "SAY");              // type = "SAY"
    lua_setfield(L, -2, "type");

    lua_pushstring(L, msg.c_str());                // text = msg
    lua_setfield(L, -2, "text");

    return lua_yield(L, 1);                // yield table
}

int Lua_GiveItem(lua_State* L) 
{
    const std::string& item = luaL_checkstring(L, 1);

    lua_newtable(L);                       // create table
    lua_pushstring(L, "CMD");              // type = "CMD"
    lua_setfield(L, -2, "type");

    lua_pushstring(L, "GiveItem");         // command = "GiveItem"
    lua_setfield(L, -2, "command");

    lua_pushstring(L, item.c_str());               // value = "Sword"
    lua_setfield(L, -2, "value");

    return lua_yield(L, 1);                // yield table
}

int Lua_SetState(lua_State* L) 
{
    // Expecting 2 string arguments: (entityName, textureID)
    const std::string& nameID = luaL_checkstring(L, 1);
    const std::string& textureID = luaL_checkstring(L, 2);

    // Call your C++ implementation
    Director::Get().SetEntityTexture( nameID, textureID);

    return 0; // No return values
}

int Lua_SetActive(lua_State* L) 
{
    int argc = lua_gettop(L);
    const std::string& nameID = luaL_checkstring(L, 1);
    bool active = true; // default

    if (argc >= 2)
        active = lua_toboolean(L, 2);

    Director::Get().SetEntityActive(nameID, active);

    return 0;
}

int Lua_SetVisible(lua_State* L) 
{
    int argc = lua_gettop(L);
    const std::string& nameID = luaL_checkstring(L, 1);
    bool visible = true; // default

    if (argc >= 2)
        visible = lua_toboolean(L, 2);

    Director::Get().SetEntityVisible(nameID, visible);

    return 0;
}

int Lua_SetPosition(lua_State* L)
{
    // Expecting: (string entityID, number x, number y)
    const std::string& nameID = luaL_checkstring(L, 1);

    if (Entity* entity = Director::Get().GetEntity(nameID))
    {
        float x = (float)luaL_checknumber(L, 2);
        float y = (lua_gettop(L) >= 3) ?
            (float)luaL_checknumber(L, 3) :
            entity->GetPositionY(); // or similar

        Director::Get().SetEntityPosition(nameID, x, y);
    }

    return 0;
}

int Lua_SetEntityScene(lua_State* L) 
{
    // Expecting: (string entityID, string sceneID)
    const std::string& nameID = luaL_checkstring(L, 1);
    const std::string& sceneID = luaL_checkstring(L, 2);

    Game::Get().Scenes.ChangeEntityScene(nameID, sceneID);

    return 0;
}

int Lua_SetCurrentScene(lua_State* L)
{
    // Expecting: (string entityID, string sceneID)
    const std::string& sceneID = luaL_checkstring(L, 1);

    Game::Get().Scenes.ChangeCurrent(sceneID);

    return 0;
}

int Lua_DeinitializeScene(lua_State* L)
{
    // Expecting: (string entityID, string sceneID)
    const std::string& sceneID = luaL_checkstring(L, 1);

    Game::Get().Scenes.Deinitialize(sceneID);

    return 0;
}

int Lua_LoadTexture(lua_State* L)
{
    // Expecting 2 string arguments: (entityName, textureID)
    const std::string& textureID = luaL_checkstring(L, 1);
    const std::string& texturePath = luaL_checkstring(L, 2);

    // Call your C++ implementation
    Assets::Get().LoadTextureID(textureID, texturePath);

    return 0; // No return values
}


void RegisterLuaFunctions() // C++ Foo Register in Lua
{
    LuaManager::Get().RegisterFunction("traceback", traceback);

    LuaManager::Get().RegisterFunction("Say", Lua_Say);

    LuaManager::Get().RegisterFunction("GiveItem", Lua_GiveItem);

    LuaManager::Get().RegisterFunction("SetState", Lua_SetState);

    LuaManager::Get().RegisterFunction("SetActive", Lua_SetActive);
   
    LuaManager::Get().RegisterFunction("SetVisible", Lua_SetVisible);

    LuaManager::Get().RegisterFunction("SetPosition", Lua_SetPosition);

    LuaManager::Get().RegisterFunction("SetScene", Lua_SetEntityScene);

    LuaManager::Get().RegisterFunction("SetCurrentScene", Lua_SetCurrentScene);

    LuaManager::Get().RegisterFunction("Deinitialize", Lua_DeinitializeScene);

    LuaManager::Get().RegisterFunction("LoadTexture", Lua_LoadTexture);
}


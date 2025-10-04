#include "LuaFunctions.h"

#include "LuaManager.h"
#include <raylib-cpp.hpp>

// Helper for stack trace
int traceback(lua_State* L) {
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
    const char* msg = luaL_checkstring(L, 1);

    lua_newtable(L);                       // create table
    lua_pushstring(L, "SAY");              // type = "SAY"
    lua_setfield(L, -2, "type");

    lua_pushstring(L, msg);                // text = msg
    lua_setfield(L, -2, "text");

    return lua_yield(L, 1);                // yield table
}

int Lua_GiveItem(lua_State* L) 
{
    const char* item = luaL_checkstring(L, 1);

    lua_newtable(L);                       // create table
    lua_pushstring(L, "CMD");              // type = "CMD"
    lua_setfield(L, -2, "type");

    lua_pushstring(L, "GiveItem");         // command = "GiveItem"
    lua_setfield(L, -2, "command");

    lua_pushstring(L, item);               // value = "Sword"
    lua_setfield(L, -2, "value");

    return lua_yield(L, 1);                // yield table
}


void RegisterLuaFunctions() // C++ Foo Register in Lua
{
    LuaManager::Get().RegisterFunction("traceback", traceback);

    LuaManager::Get().RegisterFunction("Say", Lua_Say);

    LuaManager::Get().RegisterFunction("GiveItem", Lua_GiveItem);
}


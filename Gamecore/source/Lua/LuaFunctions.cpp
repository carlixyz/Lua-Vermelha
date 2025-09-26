#include "LuaFunctions.h"

#include "LuaManager.h"
#include <raylib-cpp.hpp>

// Example native functions
int Lua_ShowDialog(lua_State* L) 
{
    const char* msg = luaL_checkstring(L, 1);
    std::cout << "[Dialog]: " << msg << std::endl;

    BeginDrawing();
    DrawText(TextFormat("[Dialog]: %s", msg), 20, 60, 20, DARKGREEN);
    EndDrawing();

    return 0;
}

int Lua_GiveItem(lua_State* L) 
{
    const char* item = luaL_checkstring(L, 1);
    
    std::cout << "[Item]: " << item << " added to inventory." << std::endl;

    DrawText(TextFormat("[Item]: %i", item), 20, 60, 20, DARKGREEN);

    return 0;
}




void RegisterLuaFunctions() // C++ Foo Register in Lua
{
    LuaManager::Get().RegisterFunction("ShowDialog", Lua_ShowDialog);

    LuaManager::Get().RegisterFunction("GiveItem", Lua_GiveItem);
}


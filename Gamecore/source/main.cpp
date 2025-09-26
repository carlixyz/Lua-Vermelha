

#include "Game/Game.h"

//#include <lua.hpp>
#include <iostream>
#include <fstream>
#include <string>


//// Function exposed to JS
//int run_lua() {
//    lua_State* L = luaL_newstate();
//    luaL_openlibs(L);
//
//    const char* script = "print('Hello from Lua in WebAssembly!')";
//    if (luaL_dostring(L, script) != LUA_OK) {
//        const char* error = lua_tostring(L, -1);
//        printf("Lua Error: %s\n", error);
//    }
//
//    lua_close(L);
//    return 0;
//}


int main(int argc, char* argv[])
{
    Game::Get().Init();

    while (!Game::Get().HasFinished())
    {
        Game::Get().Update();

        Game::Get().Render();
    }

    Game::Get().Deinit();


    //return run_lua();
    return 0;
}



#include "Game/Game.h"

//#include <lua.hpp>
#include <iostream>
#include <fstream>
#include <string>


int main(int argc, char* argv[])
{
    Game::Get().Init();

    while (!Game::Get().HasFinished())
    {
        Game::Get().Update(GetFrameTime());

        Game::Get().Render();
    }

    Game::Get().Deinit();


    //return run_lua();
    return 0;
}

#include "LuaManager.h"
#include <raylib-cpp.hpp>
#include <cassert>

bool LuaManager::Init()
{
    L = luaL_newstate();
    luaL_openlibs(L);

    std::cout << "Lua version: " << LUA_VERSION << std::endl;
#ifdef LUAJIT_VERSION
    std::cout << "LuaJIT: " << LUAJIT_VERSION << std::endl;
#endif

    RegisterLuaFunctions();

    // Load script and create coroutine
    assert(LoadScript("data/Scripts/test1.lua"));

    coId = CreateCoroutine("Cutscene");

    state = StepCoroutine(coId); // first step

    return true;
}

bool LuaManager::Deinit()
{
    lua_close(L);

    return true;
}

void LuaManager::Update()
{

    if (IsKeyPressed(KEY_SPACE) && state != "FINISHED") 
    {
        state = StepCoroutine(coId);
    }
}

void LuaManager::Render()
{
    DrawText("Press SPACE to advance cutscene", 20, 20, 20, DARKGRAY);

    DrawText(TextFormat("State: %s", state.c_str()), 20, 60, 20, BLUE);

}

bool LuaManager::LoadScript(const std::string& path)
{
    if (luaL_dofile(L, path.c_str()) != LUA_OK) 
    {
        std::cerr << "Lua error: " << lua_tostring(L, -1) << std::endl;
        lua_pop(L, 1);
        return false;
    }
    return true;
}

void LuaManager::RegisterFunction(const std::string& funcName, lua_CFunction func)
{
    lua_register(L, funcName.c_str(), func);
}

int LuaManager::CreateCoroutine(const std::string& funcName)
{
    lua_State* co = lua_newthread(L);
    lua_getglobal(co, funcName.c_str());

    if (!lua_isfunction(co, -1)) 
    {
        std::cerr << "Function not found: " << funcName << std::endl;
        lua_pop(co, 1);
        return -1;
    }
    int id = nextCoroutineId++;
    Coroutines[id] = co;
    return id;
}

std::string LuaManager::StepCoroutine(int id)
{
    auto it = Coroutines.find(id);
    if (it == Coroutines.end()) return "INVALID";

    lua_State* co = it->second;
    int nres = 0;
    int status = lua_resume(co, nullptr, 0, &nres);

    if (status == LUA_YIELD)
    {
        std::string reason;
        if (nres >= 1 && lua_isstring(co, -1)) {
            reason = lua_tostring(co, -1);
        }
        else {
            reason = "YIELDED";
        }
        lua_pop(co, nres); // pop yield values
        return reason;
    }
    else if (status == LUA_OK)
    {
        lua_pop(co, nres); // clean up results
        Coroutines.erase(it);
        return "FINISHED";
    }
    else
    {
        const char* msg = lua_tostring(co, -1);
        if (msg) std::cerr << "Lua error: " << msg << std::endl;
        lua_pop(co, 1); // pop error
        Coroutines.erase(it);
        return "ERROR";
    }
}

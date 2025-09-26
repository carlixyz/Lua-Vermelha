#ifndef _LUA_H
#define _LUA_H

#include "LuaFunctions.h"
#include "../Utility/Singleton.h"

#include "lua.hpp"
#include <iostream>
#include <string>
#include <memory>
#include <unordered_map>


class LuaManager : public Singleton<LuaManager>
{
public:
    lua_State* GetState() { return L; }

    // Load and execute a Lua file
    bool LoadScript(const std::string& path);


    // Register a C++ function into Lua
    void RegisterFunction(const std::string& funcName, lua_CFunction func);


    // Create a coroutine for a given Lua function
    int CreateCoroutine(const std::string& funcName);


    // Step coroutine (advance execution)
    std::string StepCoroutine(int id);


	friend class Singleton<LuaManager>;

    bool Init();

    bool Deinit();

	void Update();

	void Render();

    int coId = 0;
    std::string state;

protected:
	LuaManager() { ; }

private:
    lua_State* L;
    int nextCoroutineId = 1;
    std::unordered_map<int, lua_State*> Coroutines;

};

#endif // LUA
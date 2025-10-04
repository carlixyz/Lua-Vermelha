#pragma once

#include "lua.hpp"
#include <iostream>
#include <string>
#include "../../Lua/LuaManager.h"

class LuaInterface
{

protected:
	lua_State* LuaContext = nullptr;
	int Ref = LUA_NOREF;

public:

    LuaInterface(const std::string& scriptPath) : LuaContext(LuaManager::Get().GetState())
    {
        std::cout << "Loading script: " << LuaManager::Get().AddDebugRootPath(scriptPath) << std::endl;
        if (luaL_dofile(LuaContext, LuaManager::Get().AddDebugRootPath(scriptPath).c_str()) != LUA_OK)
        {
            std::cout << "Lua error loading " << LuaManager::Get().AddDebugRootPath(scriptPath) << ": "
                << lua_tostring(LuaContext, -1) << std::endl;
            lua_pop(LuaContext, 1);
            Ref = LUA_NOREF;
        }
        else
        {
            if (!lua_isnoneornil(LuaContext, -1) && lua_istable(LuaContext, -1))
            {
                Ref = luaL_ref(LuaContext, LUA_REGISTRYINDEX);
                std::cout << "Script loaded successfully with entity table." << std::endl;
            }
            else
            {
                std::cout << "Script " << scriptPath << " returned no table." << std::endl;
                if (!lua_isnoneornil(LuaContext, -1))
                    lua_pop(LuaContext, 1); // pop only if something was pushed
                Ref = LUA_NOREF;
            }
        }
    }

    virtual ~LuaInterface()
    {
        if (Ref != LUA_NOREF)
            luaL_unref(LuaContext, LUA_REGISTRYINDEX, Ref);
    }

    // Subclasses override this to handle optional return values
    virtual void OnReturn()
    {
        if (lua_istable(LuaContext, -1))
        {
            // handle here optional values
            lua_getfield(LuaContext, -1, "NameId");
            if (lua_isstring(LuaContext, -1))
            {
                std::cout << "Entity -> NameId: " << lua_tostring(LuaContext, -1) << std::endl;
            }
            lua_pop(LuaContext, 1);
        }
    }

    bool Call(const std::string& funcName)
    {
        auto tryTable = [&](int idx) -> bool
            {
                if (!lua_istable(LuaContext, idx))
                    return false;

                lua_getfield(LuaContext, idx, funcName.c_str());
                if (!lua_isfunction(LuaContext, -1))
                {
                    lua_pop(LuaContext, 1);                 // not a function
                    return false;
                }

                if (lua_pcall(LuaContext, 0, 1, 0) != LUA_OK)
                {
                    std::cerr << "Lua error in " << funcName << ": "
                        << lua_tostring(LuaContext, -1) << std::endl;
                    lua_pop(LuaContext, 1);                 // pop error
                    return false;
                }

                if (!lua_isnil(LuaContext, -1))
                    OnReturn();                             // optional result handling

                lua_pop(LuaContext, 1);                     // pop result (nil or value)
                return true;
            };

        // 1) Try entity table ONLY if valid
        if (Ref != LUA_NOREF)
        {
            lua_rawgeti(LuaContext, LUA_REGISTRYINDEX, Ref);
            bool ok = tryTable(-1);
            lua_pop(LuaContext, 1);                     // pop entity table
            if (ok) return true;
        }

        // 2) Fallback: Globals[funcName]
        lua_getglobal(LuaContext, "Globals");
        bool ok = tryTable(-1);
        lua_pop(LuaContext, 1);                         // pop Globals (table or nil)

        return ok;
    }

};
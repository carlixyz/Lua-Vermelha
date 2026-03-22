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

    int GetRef() { return Ref; }

    LuaInterface(int tableIndex) : LuaContext(LuaManager::Get().GetState())
    {
        if (lua_istable(LuaContext, tableIndex))
        {
            // Make sure we’re referencing the absolute index
            int absIndex = lua_absindex(LuaContext, tableIndex);
            lua_pushvalue(LuaContext, absIndex);
            Ref = luaL_ref(LuaContext, LUA_REGISTRYINDEX);

            std::cout << "[LuaInterface] Embedded table stored (ref " << Ref << ")" << std::endl;
        }
        else
        {
            Ref = LUA_NOREF;
            std::cout << "[LuaInterface] Invalid embedded script table." << std::endl;
        }
    }

    LuaInterface(const std::string& scriptPath) : LuaContext(LuaManager::Get().GetState())
    {
        //std::cout << "Loading script: " << LuaManager::Get().AddDebugRootPath(scriptPath) << std::endl;
        if (luaL_dofile(LuaContext, LuaManager::Get().AddDebugRootPath(scriptPath).c_str()) != LUA_OK)
        {
            std::cout << "Lua error loading script path " << LuaManager::Get().AddDebugRootPath(scriptPath) << ": "
                << lua_tostring(LuaContext, -1) << std::endl;
            lua_pop(LuaContext, 1);
            Ref = LUA_NOREF;
        }
        else
        {
            if (!lua_isnoneornil(LuaContext, -1) && lua_istable(LuaContext, -1))
            {
                std::cout << "Script " << scriptPath << " loaded successfully with entity table." << std::endl;
                Ref = luaL_ref(LuaContext, LUA_REGISTRYINDEX);
            }
            else
            {
                std::cout << "Script " << LuaManager::Get().AddDebugRootPath(scriptPath) << " returned no table." << std::endl;
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
                std::cout << "Lua error in " << funcName << ": "
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

    bool Call(const std::string& funcName, const std::string& arg)
    {
        auto tryTable = [&](int idx) -> bool
            {
                if (!lua_istable(LuaContext, idx))
                    return false;

                lua_getfield(LuaContext, idx, funcName.c_str());   // stack: ... table func
                if (!lua_isfunction(LuaContext, -1))
                {
                    lua_pop(LuaContext, 1);                        // pop non-function
                    return false;
                }

                lua_pushstring(LuaContext, arg.c_str());           // stack: ... table func arg

                // 1 argument, 0 return values (we don't care about a result for OnCombine)
                if (lua_pcall(LuaContext, 1, 0, 0) != LUA_OK)
                {
                    std::cout << "Lua error in " << funcName << ": "
                        << lua_tostring(LuaContext, -1) << std::endl;
                    lua_pop(LuaContext, 1);                        // pop error
                    return false;
                }

                // no result to pop, only the table remains on stack at idx
                return true;
            };

        // 1) Try the entity's table first (Ref)
        if (Ref != LUA_NOREF)
        {
            lua_rawgeti(LuaContext, LUA_REGISTRYINDEX, Ref);   // push entity table
            bool ok = tryTable(-1);
            lua_pop(LuaContext, 1);                            // pop entity table
            if (ok) return true;
        }

        // 2) Fallback to Globals[funcName]
        lua_getglobal(LuaContext, "Globals");                  // push Globals (table or nil)
        bool ok = tryTable(-1);
        lua_pop(LuaContext, 1);                                // pop Globals

        return ok;
    }


};
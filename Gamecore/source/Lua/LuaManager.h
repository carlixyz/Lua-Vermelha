#ifndef _LUA_H
#define _LUA_H

#include "LuaFunctions.h"
#include "../Utility/Singleton.h"

#include "lua.hpp"
#include <iostream>
#include <string>
#include <memory>
#include <unordered_map>


enum class StepResult
{
    Running,
    Finished,
    Error
};

struct ScriptedSequence
{
    int SelectedIndex = 0;
    std::vector<std::string> CurrentOptions;                    // Used for both SAY (size == 1) and CHOICE (size > 1)

    ScriptedSequence(lua_State* mainL, const std::string& funcName)
    {
        Thread = lua_newthread(mainL);
        lua_getglobal(Thread, funcName.c_str());
    }

    // Advance without args (SAY > next)
    inline StepResult Step() { return ResumeCore(0); }

    // Advance with a selected choice (CHOICE  > branch)
    inline StepResult ResumeChoice(int index)
    {
        lua_pushinteger(Thread, index);
        return ResumeCore(1);
    }

    // Helper for readability in Update/Render
    inline bool IsMultiChoice() const { return HasMultipleChoice; }

    inline bool IsRunning() const { return lua_status(Thread) == LUA_YIELD; }

private:
    lua_State* Thread = nullptr;
    bool HasMultipleChoice = false;                             // true = CHOICE, false = SAY

    StepResult ResumeCore(int nargs)
    {
        int nres = 0;
        int status = lua_resume(Thread, nullptr, nargs, &nres);

        if (status == LUA_OK)
            return StepResult::Finished;

        if (status == LUA_YIELD && nres > 0 && lua_istable(Thread, -1))
        {
            ParseYield();
            lua_pop(Thread, 1);                                 // pop yield table
            return StepResult::Running;
        }

        if (const char* error = lua_tostring(Thread, -1))
            std::cout << "Lua error: " << (error ? error : "unknown") << std::endl;

        lua_pop(Thread, 1);

        return StepResult::Error;
    }

    void ParseYield()
    {
        lua_getfield(Thread, -1, "type");
        std::string type = lua_isstring(Thread, -1) ? lua_tostring(Thread, -1) : "";
        lua_pop(Thread, 1);

        CurrentOptions.clear();
        HasMultipleChoice = false;

        if (type == "SAY")
        {
            lua_getfield(Thread, -1, "text");
            if (lua_isstring(Thread, -1))
                CurrentOptions.emplace_back(lua_tostring(Thread, -1));
            lua_pop(Thread, 1);
        }
        else if (type == "CHOICE")
        {
            HasMultipleChoice = true;
            lua_getfield(Thread, -1, "options");
            int n = (int)lua_rawlen(Thread, -1);
            for (int i = 1; i <= n; i++)
            {
                lua_rawgeti(Thread, -1, i);
                if (lua_isstring(Thread, -1))
                    CurrentOptions.emplace_back(lua_tostring(Thread, -1));
                lua_pop(Thread, 1);
            }
            lua_pop(Thread, 1);
        }

        // ensure SelectedIndex stays valid
        SelectedIndex = (int)(CurrentOptions.empty() ? 0 :
            (unsigned)SelectedIndex % CurrentOptions.size());
    }
};

class LuaManager : public Singleton<LuaManager>
{
public:
    bool Init();
    
    bool Deinit();

    void Update();

    void Render();

    lua_State* GetState() { return L; }

    inline bool IsSequenceRunning() const { return sequence && sequence->IsRunning(); }

    // Load and execute a Lua file
    bool LoadScript(const std::string& path);

    // Register a C++ function into Lua
    void RegisterFunction(const std::string& funcName, lua_CFunction func);

    void StartSequence(const std::string& funcName);

    void StepSequence();

    void ResumeChoice(int choiceIndex);

    std::unique_ptr<ScriptedSequence> sequence;

    friend class Singleton<LuaManager>;

protected:
    LuaManager() = default;
    lua_State* L = nullptr;
};

#endif // _LUA_H
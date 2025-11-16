#ifndef _LUA_H
#define _LUA_H

#include "LuaFunctions.h"
#include "../Utility/Singleton.h"
#include "../Graphics/Graphics.h"
#include "lua.hpp"
#include <iostream>
#include <string>
#include <memory>
#include <unordered_map>

struct ScriptedSequence
{
    int SelectedIndex = 0;
    std::vector<std::string> CurrentOptions;
    float Duration = -1.0f;
    bool AutoStep = false;

    ScriptedSequence(lua_State* mainL, const std::string& funcName)
    {
        Thread = lua_newthread(mainL);
        lua_getglobal(Thread, funcName.c_str());
    }

    ScriptedSequence(lua_State* existingThread) { Thread = existingThread; }

    inline bool IsMultiChoice() const { return HasMultipleChoice; }

    inline bool IsRunning() const { return lua_status(Thread) == LUA_YIELD; }

    // ---- main step (for SAY) ----
    inline void Step() { ResumeCore(0); }

    // ---- step with choice index ----
    inline void ResumeChoice(int index) 
    {
        lua_pushinteger(Thread, index);
        ResumeCore(1);
    }

private:
    lua_State* Thread = nullptr;
    bool HasMultipleChoice = false;

    // ---- Resume coroutine ----
    inline void ResumeCore(int nargs)
    {
        int nres = 0;
        int status = lua_resume(Thread, nullptr, nargs, &nres);

        if (status == LUA_OK)
            return;             // coroutine finished normally

        if (status == LUA_YIELD && nres > 0 && lua_istable(Thread, -1))
        {
            ParseYield();
            lua_pop(Thread, 1); // pop the yield table
            return;
        }

        // --- If we got here, something went wrong ---
        if (const char* error = lua_tostring(Thread, -1))
            std::cout << "Lua error: " << (error ? error : "unknown") << std::endl;

        lua_pop(Thread, 1);
    }

    // ---- Parse yielded table from Lua ----
    inline void ParseYield()
    {
        // Make sure CurrentOptions is clean and we won't accidentally keep duration
        CurrentOptions.clear();
        HasMultipleChoice = false;
        Duration = -1.0f; // default unset unless overridden

        lua_getfield(Thread, -1, "type");
        std::string type = lua_isstring(Thread, -1) ? lua_tostring(Thread, -1) : "";
        lua_pop(Thread, 1);

        CurrentOptions.clear();
        HasMultipleChoice = false;

        // ----- SAY -----
        if (type == "SAY")
        {
            std::string speaker;
            lua_getfield(Thread, -1, "speaker");
            if (lua_isstring(Thread, -1))
                speaker = lua_tostring(Thread, -1);
            lua_pop(Thread, 1);

            std::string text;
            lua_getfield(Thread, -1, "text");
            if (lua_isstring(Thread, -1))
                text = lua_tostring(Thread, -1);
            lua_pop(Thread, 1);

            // read duration WITHOUT inserting into text
            lua_getfield(Thread, -1, "duration");
            if (lua_isnumber(Thread, -1))
                Duration = (float)lua_tonumber(Thread, -1);
            lua_pop(Thread, 1);

            //  remove duration from table so UI never sees it
            lua_pushnil(Thread);
            lua_setfield(Thread, -2, "duration");

            //   DO NOT append duration to text!
            if (!speaker.empty())
                CurrentOptions.emplace_back("[" + speaker + "]#" + text);
            else
                CurrentOptions.emplace_back(text);

            //return;
        }


        // ----- CHOICE -----
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
            lua_pop(Thread, 1); // pop "options" table
        }

        // ensure selection stays valid
        SelectedIndex = (int)(CurrentOptions.empty() ? 0 :
            (unsigned)SelectedIndex % CurrentOptions.size());
    }
};



class LuaManager : public Singleton<LuaManager>
{
    LuaManager() = default;

    lua_State* LuaContext = nullptr;
    std::unique_ptr<ScriptedSequence> sequence;

    bool UseRootPathScripts = true;
    bool hoveredAny = false;
    bool messageComplete = true;

    int TextX = (int)(GetScreenWidth() * 0.2f);
    int TextY = (int)(GetScreenHeight() * 0.75f);
    int FontSize = 24;

    int visibleChars = 0;
    float typeTimer = 0.0f;
    float typeSpeed = 0.03f; // seconds per character

public:
    bool Init();
    bool Deinit();

    void Update(float deltaTime);
    void Render();

    void StartSequence(const std::string& funcName);
    void StartSequence(lua_State* L);
    void StopSequence();

    void Advance(int choiceIndex = -1);
    void ResetTypewriter();

    lua_State* GetState() { return LuaContext; }

    bool IsSequenceRunning() const { return sequence && sequence->IsRunning(); }
    bool LoadScript(const std::string& path);

    void RegisterFunction(const std::string& funcName, lua_CFunction func);
    std::string AddDebugRootPath(const std::string& input);

    friend class Singleton<LuaManager>;
};

#endif // _LUA_H

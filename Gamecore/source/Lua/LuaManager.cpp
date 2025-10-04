#include "LuaManager.h"
#include <raylib-cpp.hpp>
#include <cassert>
#include "../Game/Game.h"

bool LuaManager::Init()
{
    LuaContext = luaL_newstate();

    luaL_openlibs(LuaContext);

    std::cout << "Lua version: " << LUA_VERSION << std::endl;
#ifdef LUAJIT_VERSION
    std::cout << "LuaJIT: " << LUAJIT_VERSION << std::endl;
#endif

    RegisterLuaFunctions();

    if (!LoadScript("data/Scripts/globals.lua"))
        std::cout << "Failed to load script!" << " globals.lua" << std::endl;

    //if (!LoadScript("data/Scripts/test1.lua")) 
    //    std::cout << "Failed to load script!" << " test1.lua" << std::endl;

    //StartSequence("OurTalkTest");

    return true;
}

bool LuaManager::Deinit()
{
    lua_close(LuaContext);

    return true;
}

void LuaManager::Update()
{
    if (!sequence || !sequence->IsRunning()) return;

    if (sequence->IsMultiChoice())
    {
        if (IsKeyPressed(KEY_DOWN))
            sequence->SelectedIndex = (int)Wrap((float)(sequence->SelectedIndex +1), 
                0.0f, (float)sequence->CurrentOptions.size());
        else if (IsKeyPressed(KEY_UP))
            sequence->SelectedIndex = (int)Wrap((float)(sequence->SelectedIndex -1), 
                0.0f, (float)sequence->CurrentOptions.size());

        if (IsKeyPressed(KEY_SPACE))
            if (StepResult::Error == sequence->ResumeChoice(sequence->SelectedIndex + 1))
                std::cout << "Error resuming with choice!" << std::endl;
    }
    else
    {
        if (IsKeyPressed(KEY_SPACE))
            if (StepResult::Error == sequence->Step())
                std::cout << "Error stepping sequence!" << std::endl;
    }
}

void LuaManager::Render()
{
    if (!sequence) return;

    if (!sequence->CurrentOptions.empty())
    {
        if (sequence->IsMultiChoice())                          // CHOICE
        {
            for (int i = 0; i < (int)sequence->CurrentOptions.size(); i++)
            {
                Color color = (i == sequence->SelectedIndex) ? YELLOW : DARKGRAY;
                DrawText(sequence->CurrentOptions[i].c_str(),
                    40, 120 + 30 * (int)i, 20, color);
            }
        }
        else                                                    // SAY
        {
            DrawText(sequence->CurrentOptions[0].c_str(), 20, 60, 20, BLUE);
        }
    }
}

bool LuaManager::LoadScript(const std::string& path) 
{
    std::cout << "Loading script: " << AddDebugRootPath(path) << std::endl;

    if (luaL_dofile(LuaContext, AddDebugRootPath(path).c_str()) != LUA_OK)
    {
        const char* err = lua_tostring(LuaContext, -1);
        std::cout << "Lua error: " << (err ? err : "unknown") << std::endl;
        lua_pop(LuaContext, 1);
        return false;
    }

    std::cout << "Script loaded successfully." << std::endl;
    return true;
}

std::string LuaManager::AddDebugRootPath(const std::string& input)
{
    /// I use this function because sometimes the data folder duplication takes time
    /// So We check the original root scripts to re-load values inmediately ASAP
#ifdef EMSCRIPTEN   // Defined by MSVC when building Debug
    return input;  // Release or other builds
#elif _DEBUG
    if (UseRootPathScripts)
        return "../../../" + input;
    else
        return input;  // Release or other builds
#endif
}

void LuaManager::RegisterFunction(const std::string& funcName, lua_CFunction func)
{
    lua_register(LuaContext, funcName.c_str(), func);
}

inline void LuaManager::StartSequence(const std::string& funcName)  // Start a scripted sequence
{
    lua_getglobal(LuaContext, funcName.c_str());     // Push the function onto the stack

    if (!lua_isfunction(LuaContext, -1))
    {
        std::cout << "[LuaManager] StartSequence: function '"
            << funcName << "' not found in Lua\n";
        lua_pop(LuaContext, 1); // remove non-function from stack
        return;
    }

    sequence = std::make_unique<ScriptedSequence>(LuaContext, funcName);
    sequence->Step();                                               // run first line immediately
}

void LuaManager::StepSequence()                                     // Step explicitly (for SAY)
{
    if (sequence && sequence->IsRunning())
        sequence->Step();
}

void LuaManager::ResumeChoice(int choiceIndex)
{
    if (sequence && sequence->IsRunning())
        sequence->ResumeChoice(choiceIndex);
}

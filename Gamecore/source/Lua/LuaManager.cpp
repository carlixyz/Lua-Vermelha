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

    if (!LoadScript("data/Scripts/utils.lua"))
        std::cout << "Failed to load script!" << " utils.lua" << std::endl;

    if (!LoadScript("data/Scripts/test1.lua")) 
        std::cout << "Failed to load script!" << " test1.lua" << std::endl;

    StartSequence("Talk");

    return true;
}

bool LuaManager::Deinit()
{
    lua_close(L);

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
    std::cout << "Loading script: " << path << std::endl;

    if (luaL_dofile(L, path.c_str()) != LUA_OK) 
    {
        const char* err = lua_tostring(L, -1);
        std::cout << "Lua error: " << (err ? err : "unknown") << std::endl;
        lua_pop(L, 1);
        return false;
    }

    std::cout << "Script loaded successfully." << std::endl;
    return true;
}

void LuaManager::RegisterFunction(const std::string& funcName, lua_CFunction func)
{
    lua_register(L, funcName.c_str(), func);
}

inline void LuaManager::StartSequence(const std::string& funcName)  // Start a scripted sequence
{
    sequence = std::make_unique<ScriptedSequence>(L, funcName);
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

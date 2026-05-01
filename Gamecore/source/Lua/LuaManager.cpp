#include "LuaManager.h"
#include <raylib-cpp.hpp>
#include "../Game/Game.h"
#include "../Game/Assets.h"

bool LuaManager::IsDummyChoice(int index) const
{
    if (!sequence) return true;
    if (index < 0 || index >= (int)sequence->CurrentOptions.size()) return true;

    const std::string& text = sequence->CurrentOptions[index];
    return text.find_first_not_of(" \t\n\r") == std::string::npos;
}

void LuaManager::ClampSelectionToValidChoice(int direction)
{
    if (!sequence || sequence->CurrentOptions.empty())
        return;

    const int count = (int)sequence->CurrentOptions.size();

    // If there are no valid visible choices, keep 0
    bool foundAny = false;
    for (int i = 0; i < count; ++i)
    {
        if (!IsDummyChoice(i))
        {
            foundAny = true;
            break;
        }
    }

    if (!foundAny)
    {
        sequence->SelectedIndex = 0;
        return;
    }

    int idx = sequence->SelectedIndex;
    for (int step = 0; step < count; ++step)
    {
        idx = (idx + direction + count) % count;
        if (!IsDummyChoice(idx))
        {
            sequence->SelectedIndex = idx;
            return;
        }
    }
}

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
        std::cout << "Failed to load globals.lua\n";

    return true;
}

bool LuaManager::Deinit()
{
    lua_close(LuaContext);
    return true;
}

void LuaManager::Update(float deltaTime)
{
    if (!sequence || !sequence->IsRunning()) return;

    // === CHOICE MODE ===
    if (sequence->IsMultiChoice())
    {
        hoveredAny = false;

        for (int i = 0; i < (int)sequence->CurrentOptions.size(); i++)
        {
            if (IsDummyChoice(i))
                continue;

            int textY = ChoiceY + 30 * i;
            int textWidth = MeasureText(sequence->CurrentOptions[i].c_str(), FontSize);

            Rectangle rect = { (float)TextX - 8, (float)textY - 4,
                               (float)textWidth + 16, (float)FontSize + 8 };

            if (CheckCollisionPointRec(GetMousePosition(), rect))
            {
                sequence->SelectedIndex = i;
                hoveredAny = true;

                if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON))
                {
                    Advance(sequence->SelectedIndex + 1);
                    return;
                }
            }
        }

        if (!hoveredAny)
        {
            if (IsKeyPressed(KEY_DOWN))
                ClampSelectionToValidChoice(1);
            else if (IsKeyPressed(KEY_UP))
                ClampSelectionToValidChoice(-1);
        }

        if (IsKeyPressed(KEY_SPACE) && !IsDummyChoice(sequence->SelectedIndex))
            Advance(sequence->SelectedIndex + 1);

        return;
    }

    // === SAY MODE ===
    if (sequence->CurrentOptions.empty()) return;

    const std::string& full = sequence->CurrentOptions[0];
    size_t newlinePos = full.find('#');
    std::string line = (newlinePos != std::string::npos) ? full.substr(newlinePos + 1) : full;
    int totalLen = (int)line.size();

    if (!messageComplete)
    {
        typeTimer += deltaTime;
        while (typeTimer >= typeSpeed && visibleChars < totalLen)
        {
            typeTimer -= typeSpeed;
            visibleChars++;
        }
        
        if (visibleChars >= totalLen) 
            messageComplete = true;
    }

    if (sequence->Duration > 0.0f)
        sequence->Duration = Clamp(sequence->Duration - deltaTime, 0.0f, 100.f);

    if ((sequence->Duration == 0.0f && messageComplete) || IsKeyPressed(KEY_SPACE) ||
        IsMouseButtonPressed(MOUSE_LEFT_BUTTON) || IsMouseButtonPressed(MOUSE_RIGHT_BUTTON) )
    {
        if (!messageComplete)
        {
            visibleChars = totalLen;
            messageComplete = true;
        }
        else Advance();
    }
}

void LuaManager::Render()
{
    if (!sequence || sequence->CurrentOptions.empty()) return;

    if (sequence->IsMultiChoice())
    {
        static float hoverPulse = 0.0f;
        hoverPulse += GetFrameTime() * 3.0f;
        float pulse = (sinf(hoverPulse) * 0.5f + 0.5f);

        CurrentAlpha += GetFrameTime() * 2;
        CurrentAlpha = Clamp(CurrentAlpha, 0.f, ShadeAlpha);
        DrawTexture(GetTexture("Shade"), 0, 316, ColorAlpha(WHITE, CurrentAlpha));

        DrawTexture(GetTexture(Emotion), 16, 290, ColorAlpha(WHITE, CurrentAlpha * 2));

        for (int i = 0; i < (int)sequence->CurrentOptions.size(); i++)
        {
            if (IsDummyChoice(i))
                continue;

            int textY = ChoiceY + 30 * i;
            const char* text = sequence->CurrentOptions[i].c_str();
            bool isSelected = (i == sequence->SelectedIndex);

            if (isSelected)
                DrawRectangle(TextX - 8, textY - 4, MeasureText(text, FontSize) + 16, FontSize + 8,
                    Fade(RAYWHITE, 0.2f + 0.3f * pulse));

            Color color = isSelected ? BLACK : GRAY;
            DrawTextEx(GetFont("Noto"), text, { (float)TextX, (float)textY }, (float)FontSize, 1.0f, color);
        }

        DrawTexture(GetTexture(hoveredAny ? "MB" : "MA"), (int)GetMouseX(), (int)GetMouseY(), WHITE);
        return;
    }

    const std::string& full = sequence->CurrentOptions[0];
    size_t sepPos = full.find('#');
    std::string speaker, line;

    if (sepPos != std::string::npos) {
        speaker = full.substr(0, sepPos);
        line = full.substr(sepPos + 1);
    }
    else line = full;

    int charsToShow = std::min(visibleChars, (int)line.size());
    const bool textVisible = charsToShow > 0;
    const bool speakerVisible = !speaker.empty();

    CurrentAlpha += (textVisible || speakerVisible) ? GetFrameTime()*2 : -GetFrameTime()*.25f;
    CurrentAlpha = Clamp(CurrentAlpha, 0.f, ShadeAlpha);
    DrawTexture(GetTexture("Shade"), 0, 316, ColorAlpha(WHITE, CurrentAlpha));

    DrawTexture(GetTexture(Emotion), 16, 290, ColorAlpha(WHITE, CurrentAlpha *2));

    if (speakerVisible)
        DrawTextEx(GetFont("Noto"), speaker.c_str(),
            { (float)TextX, (float)TextY - 30 },
            (float)FontSize, 1.0f, Fade(WHITE, 0.9f));

    if (textVisible)
    {
        std::string partial = line.substr(0, charsToShow);
        DrawTextEx(GetFont("Noto"), partial.c_str(),
            { (float)TextX, (float)TextY },
            (float)FontSize, 1.0f, WHITE);
    }
}

void LuaManager::Advance(int choiceIndex)
{
    if (!sequence || !sequence->IsRunning())
        return;

    if (choiceIndex >= 0)
        sequence->ResumeChoice(choiceIndex);
    else
        sequence->Step();

    if (sequence && sequence->IsMultiChoice())
    {
        sequence->SelectedIndex = -1;
        ClampSelectionToValidChoice(1);
    }

    ResetTypewriter();
}

void LuaManager::ResetTypewriter()
{
    visibleChars = 0;
    typeTimer = 0.0f;
    messageComplete = false;
}

void LuaManager::StopSequence()
{
    if (sequence)
    {
        std::cout << "[LuaManager] Sequence manually ended.\n";
        sequence.reset();
    }
}

bool LuaManager::LoadScript(const std::string& path)
{
    std::cout << "Loading script: " << AddDebugRootPath(path) << std::endl;
    if (luaL_dofile(LuaContext, AddDebugRootPath(path).c_str()) != LUA_OK)
    {
        std::cout << "Lua error: " << lua_tostring(LuaContext, -1) << std::endl;
        lua_pop(LuaContext, 1);
        return false;
    }
    std::cout << "Script loaded successfully.\n";
    return true;
}

void LuaManager::RegisterFunction(const std::string& funcName, lua_CFunction func)
{
    lua_register(LuaContext, funcName.c_str(), func);
}

std::string LuaManager::AddDebugRootPath(const std::string& input)
{
#ifdef EMSCRIPTEN
    return input;
#elif _DEBUG
    return UseRootPathScripts ? "../../../" + input : input;
#else
    return input;
#endif
}

void LuaManager::StartSequence(const std::string& funcName)
{
    lua_getglobal(LuaContext, funcName.c_str());
    if (!lua_isfunction(LuaContext, -1))
    {
        std::cout << "[LuaManager] StartSequence: function '" << funcName << "' not found\n";
        lua_pop(LuaContext, 1);
        return;
    }

    sequence = std::make_unique<ScriptedSequence>(LuaContext, funcName);
    sequence->Step();
    if (sequence && sequence->IsMultiChoice())
    {
        sequence->SelectedIndex = -1;
        ClampSelectionToValidChoice(1);
    }

    ResetTypewriter();
}

void LuaManager::StartSequence(lua_State* L)
{
    if (!lua_isfunction(L, 1))
    {
        std::cout << "[Lua] StartSequence expects a function argument\n";
        return;
    }

    lua_State* threadL = lua_newthread(L);
    lua_pushvalue(L, 1);
    lua_xmove(L, threadL, 1);

    sequence = std::make_unique<ScriptedSequence>(threadL);
    sequence->Step();
    if (sequence && sequence->IsMultiChoice())
    {
        sequence->SelectedIndex = -1;
        ClampSelectionToValidChoice(1);
    }

    ResetTypewriter();
}

#include "Credits.h"

#include "../Assets.h"
#include "../../Lua/LuaManager.h"

#include "raylib.h"


void Credits::OnInit()
{
    GameScene::OnInit();

    scrollY = (float)GetScreenHeight();
}


void Credits::OnDeinit()
{
    lines.clear();

    GameScene::OnDeinit();
}


void Credits::OnUpdate(float deltaTime)
{
    if (!rolling || lines.empty())
        return;

    bool IsInputDown =
        IsKeyDown(KEY_SPACE) || IsMouseButtonDown(MOUSE_BUTTON_LEFT) || IsMouseButtonDown(MOUSE_BUTTON_RIGHT);

    scrollY -= scrollSpeed * deltaTime * (IsInputDown ? 4.0f : 1.0f);

    float y = scrollY;

    for (CreditLine& line : lines)
    {
        float height = 
            line.type == CreditLine::Type::Empty ? lineHeight * line.emptyLines : lineHeight;

        if (line.type == CreditLine::Type::Command && !line.executed && y < 0.0f)
        {
            line.executed = true;

            lua_State* L = LuaManager::Get().GetState();

            if (luaL_dostring(L, line.left.c_str()) != LUA_OK)
            {
                std::cout << "[Credits] Lua command error: " << lua_tostring(L, -1) << '\n';

                lua_pop(L, 1);
            }
        }

        y += height;
    }

    if (y < 0.0f)
        rolling = false;
}


void Credits::OnRender()
{
    if (!rolling || lines.empty())
        return;

    const Font& font = GetFont("Noto");

    const float fontSize = 24.0f;
    const float spacing = 1.0f;

    const float centerX = GetScreenWidth() * 0.5f;
    const float leftBorder = centerX - columnGap * 0.5f;
    const float rightBorder = centerX + columnGap * 0.5f;

    float y = scrollY;

    for (const CreditLine& line : lines)
    {
        if (line.type == CreditLine::Type::Empty)
        {
            y += lineHeight * line.emptyLines;
            continue;
        }

        if (line.type == CreditLine::Type::Command)
        {
            y += lineHeight;
            continue;
        }

        if (line.type == CreditLine::Type::Single)
        {
            Vector2 size = MeasureTextEx( font, line.left.c_str(), fontSize, spacing );

            DrawTextEx( font, line.left.c_str(), { centerX - size.x * 0.5f, y }, fontSize, spacing, WHITE );
        }
        else
        {
            Vector2 size = MeasureTextEx( font, line.left.c_str(), fontSize, spacing );

            DrawTextEx( font, line.left.c_str(), { leftBorder - size.x, y }, fontSize, spacing, WHITE);

            DrawTextEx( font, line.right.c_str(), { rightBorder, y }, fontSize, spacing, WHITE);
        }

        y += lineHeight;
    }
}


void Credits::PushSingle(const std::string& text)
{
    if (!text.empty() && text[0] == '#')
        lines.push_back({ CreditLine::Type::Command, text.substr(1) });
    else
        lines.push_back({ CreditLine::Type::Single, text });
}


void Credits::PushPair(
    const std::string& left,
    const std::string& right)
{
    lines.push_back({
        CreditLine::Type::Pair,
        left,
        right
        });
}


void Credits::PushEmpty(int count)
{
    lines.push_back({
        CreditLine::Type::Empty,
        "",
        "",
        count < 1 ? 1 : count
        });
}


void Credits::RollCredits(bool enabled)
{
    scrollY = (float)GetScreenHeight();
    rolling = enabled;

    if (enabled)
        for (CreditLine& line : lines)
            line.executed = false;
}
#include <raylib-cpp.hpp>
//#include "../Game/Assets.h"

#include <vector>
#include <string>


struct SplashTitle
{
    std::string text;
    float timeLeft = 0.0f;
    float duration = 3.0f;
    float fontSize = 60.0f;
    Vector2 position{ 0, 0 };
    Color color = RAYWHITE;
    bool active = false;

    void Start(const std::string& title,
        float duration = 3.0f,
        float size = 48.0f,
        Vector2 pos = { 0, 0 },
        Color color = RAYWHITE)
    {
        text = title;
        timeLeft = duration;
        this->duration = duration;
        fontSize = size;
        position = pos;
        this->color = color;
        active = true;
    }

    void Update(float delta)
    {
        if (!active) return;

        timeLeft -= delta;
        if (timeLeft <= 0.0f)
        {
            timeLeft = 0.0f;
            active = false;
        }
    }

    void Render()
    {
        if (!active) return;

        float lifeRatio = timeLeft / duration;
        float alpha = 1.0f;

        if (lifeRatio < 0.25f) 
            alpha = lifeRatio / 0.25f;
        else if (lifeRatio > 0.9f) 
            alpha = (1.0f - lifeRatio) / 0.1f;
        alpha = Clamp(alpha, 0.0f, 1.0f);

        Vector2 drawPos = position;
        if (position.x == 0 && position.y == 0)
        {
            Vector2 size = MeasureTextEx(GetFont("Gothic"), text.c_str(), fontSize, 1.0f);
            drawPos.x = GetScreenWidth() * 0.5f - size.x * 0.5f;
            drawPos.y = GetScreenHeight() * 0.5f - size.y * 0.5f;
        }

        DrawTextEx(GetFont("Gothic"), text.c_str(), drawPos, fontSize, 1.0f, Fade(color, alpha));
    }
};
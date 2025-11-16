#include <raylib-cpp.hpp>

#include "../../Game/Assets.h"

#include <vector>
#include <string>

struct TimedMessage
{
    std::string text;
    Vector2 position;
    float fontSize;
    float timeLeft;
    Color color;

    TimedMessage(const std::string& t, Vector2 pos, float size, float duration, Color c)
        : text(t), position(pos), fontSize(size), timeLeft(duration), color(c) { }
};

class Toaster
{
    std::vector<TimedMessage> Messages;

public:
    void AddMessage(const std::string& text, Vector2 pos, float duration = 3.0f, float size = 24.f, Color color = RAYWHITE)
    {
        Messages.emplace_back(text, pos, size, duration, color);
    }

    void Update(float deltaTime)
    {
        for (auto it = Messages.begin(); it != Messages.end(); )
        {
            it->timeLeft -= deltaTime;
            if (it->timeLeft <= 0.0f)
                it = Messages.erase(it);
            else
                ++it;
        }
    }

    void Render()
    {
        if (Messages.empty()) return;

        const float spacing = 8.0f;
        float totalY = 20.0f; // start near top of screen

        for (const auto& msg : Messages)
        {
            float alpha = (msg.timeLeft < 0.8f) ? msg.timeLeft / 0.8f : 1.0f;
            Vector2 size = MeasureTextEx(GetFont("Noto"), msg.text.c_str(), msg.fontSize, 1.0f);

            float x = GetScreenWidth() - size.x - 40.0f; // right-aligned
            float y = totalY;

            DrawTextEx(GetFont("Noto"), msg.text.c_str(),
                { x, y }, msg.fontSize, 1.0f,
                Fade(msg.color, alpha));

            totalY += size.y + spacing;
        }
    }
};
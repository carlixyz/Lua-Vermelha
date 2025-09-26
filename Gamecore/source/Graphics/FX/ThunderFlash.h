#pragma once
#include <cstdlib>
#include <ctime>

struct ThunderFlash
{
    Color flashColor = { 255, 255, 255, 0 };
    bool active = false;

    // General behavior
    float fadeSpeed = 2.0f;             // alpha units per second

    // Ambient (random auto) settings
    float ambientFrequency = 0.002f;    // chance per frame (~0.2%)
    int ambientMinAlpha = 40;           // faint glow
    int ambientMaxAlpha = 90;           // medium glow

    // Triggered (manual) settings
    int queuedTriggers = 0;
    int triggerMinAlpha = 90;           // default medium
    int triggerMaxAlpha = 160;          // default strong

    ThunderFlash()
    {
        srand((unsigned int)time(0));
    }

    void Update(float deltaTime)
    {
        // --- Triggered flash handling ---
        if (!active && queuedTriggers > 0)
        {
            StartFlash(triggerMinAlpha, triggerMaxAlpha);
            queuedTriggers--;
        }

        // --- Ambient random flash ---
        if (!active && queuedTriggers == 0 &&
            ((rand() % 10000) / 10000.0f) < ambientFrequency)
        {
            StartFlash(ambientMinAlpha, ambientMaxAlpha);
        }

        // --- Fade out ---
        if (active)
        {
            int fadeAmount = (int)(fadeSpeed * 255.0f * deltaTime);
            if (flashColor.a > fadeAmount)
                flashColor.a -= fadeAmount;
            else
            {
                flashColor.a = 0;
                active = false;
            }
        }
    }

    void Draw()
    {
        if (flashColor.a > 0)
        {
            DrawRectangle(0, 0, GetScreenWidth(), GetScreenHeight(), flashColor);
        }
    }

    // Trigger function: customizable intensity and count
    void Trigger(int count = 1, int minAlpha = 100, int maxAlpha = 180)
    {
        queuedTriggers += count;
        triggerMinAlpha = minAlpha;
        triggerMaxAlpha = maxAlpha;
    }

private:
    void StartFlash(int minAlpha, int maxAlpha)
    {
        active = true;
        flashColor.a = minAlpha + rand() % (maxAlpha - minAlpha + 1);
    }
};
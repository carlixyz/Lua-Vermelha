#pragma once
#include <cstdlib>
#include <ctime>
#include "raylib.h"

class ThunderFlash
{

public:
    ThunderFlash()
    {
        srand((unsigned int)time(nullptr));
    }

    void Enable(bool on = true) { enabled = on; }
    void Disable() { enabled = false; }

    bool IsEnabled() const { return enabled; }

    // Manual big flash trigger
    void Trigger(int count = 1, int minAlpha = 100, int maxAlpha = 180)
    {
        queuedTriggers += count;
        triggerMinAlpha = minAlpha;
        triggerMaxAlpha = maxAlpha;
    }

    void Update(float dt)
    {
        if (!enabled) 
        {
            // If disabled, still fade existing flash but do NOT start new ones
            if (active) FadeOut(dt);
            return;
        }

        // Manual queued flashes take priority
        if (!active && queuedTriggers > 0)
        {
            StartFlash(triggerMinAlpha, triggerMaxAlpha);
            queuedTriggers--;
        }

        // Ambient auto flashes only if no manual pending
        if (!active && queuedTriggers == 0 &&
            ((rand() % 10000) / 10000.0f) < ambientFrequency)
        {
            StartFlash(ambientMinAlpha, ambientMaxAlpha);
        }

        // Fade currently active flash
        if (active) FadeOut(dt);
    }

    void Render()
    {
        if (flashColor.a > 0)
        {
            DrawRectangle(0, 0, GetScreenWidth(), GetScreenHeight(), flashColor);
        }
    }

private:
    Color flashColor = { 255, 255, 255, 0 };
    bool active = false;
    bool enabled = true;

    // Fade speed
    float fadeSpeed = 2.0f;

    // Ambient automatic flashes
    float ambientFrequency = 0.002f; // ~0.2% per frame chance
    int ambientMinAlpha = 40;
    int ambientMaxAlpha = 90;

    // Manual thunder trigger storage
    int queuedTriggers = 0;
    int triggerMinAlpha = 90;
    int triggerMaxAlpha = 160;

private:
    void StartFlash(int minAlpha, int maxAlpha)
    {
        active = true;
        flashColor.a = minAlpha + rand() % (maxAlpha - minAlpha + 1);
    }

    void FadeOut(float dt)
    {
        int fadeAmount = (int)(fadeSpeed * 255.0f * dt);
        if (flashColor.a > fadeAmount)
            flashColor.a -= fadeAmount;
        else 
        {
            flashColor.a = 0;
            active = false;
        }
    }
};

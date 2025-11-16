#pragma once
#include "raylib.h"
#include <vector>

struct NoiseFX
{
    bool enabled = true;

    int textureCount = 10;          // amount of noise frames
    int currentIndex = 0;           // cycling index
    float noiseAmount = 0.3f;       // white noise intensity
    float alpha = 0.07f;            // draw transparency

    std::vector<Texture2D> frames;

    ~NoiseFX()
    {
        Unload();
    }

    void Unload()
    {
        for (auto& t : frames)
            UnloadTexture(t);
        frames.clear();
    }

    void Enable(bool on = true) { enabled = on; }
    void Disable() { enabled = false; }
    bool IsEnabled() const { return enabled; }
    void SetAlpha(float a = 0.07f) { alpha = a;  }

    void Init(int screenWidth, int screenHeight, int count = 10)
    {
        textureCount = count;
        frames.reserve(textureCount);

        for (int i = 0; i < textureCount; i++)
        {
            Image img = GenImageWhiteNoise(screenWidth, screenHeight, noiseAmount);
            frames.push_back(LoadTextureFromImage(img));
            UnloadImage(img);
        }
    }


    void Update()
    {
        if (!enabled) return;

        currentIndex++;
        currentIndex = currentIndex % 10;
    }

    void Render()
    {
        if (!enabled || frames.empty()) return;

        DrawTexture(frames[currentIndex], 0, 0, Fade(WHITE, alpha));
    }
};

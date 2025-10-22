#pragma once
#include "raylib.h"


class CurtainBlend
{
public:
    Texture2D Curtain;          // snapshot texture

    bool Active = false;
    bool Captured = false;

    float Progress = 0.0f;
    float Duration = 4.0f;

    int Width = 0;
    int Height = 0;

    CurtainBlend() = default;

    void Init(int width, int height)
    {
        Width = width;
        Height = height;
        Curtain.id = 0;                                         // not yet loaded
    }

    void Start(float delay = 2.0f)
    {
        Duration = delay;
        Progress = 0.0f;
        Captured = false;
        Active = false;                         // we’ll enable only *after* capture completes
        Capture();
    }

    // Capture current screen (snapshot of visible scene)
    void Capture()
    {
        Image CaptureImg = LoadImageFromScreen();     // get the current framebuffer image

        if (CaptureImg.data != nullptr)
        {
            if (Curtain.id > 0)
                UnloadTexture(Curtain);

            Curtain = LoadTextureFromImage(CaptureImg);
            UnloadImage(CaptureImg);

            Active = true;                                      // ready to render
            Captured = true;                                    // capture complete
        }

    }

    void Update(float dt)
    {
        if (!Active) return;

        Progress += dt / Duration;
        if (Progress >= 1.0f)
        {
            Progress = 1.0f;
            Active = false;
            Captured = false;
        }
    }

    void Render()
    {
        if (!Active || Curtain.id == 0) return;

        float alphaValue = 1.0f - Progress;

        DrawTextureRec(Curtain, { 0, 0, (float)Width, (float)Height }, { 0, 0 }, ColorAlpha(WHITE, alphaValue));
    }
};

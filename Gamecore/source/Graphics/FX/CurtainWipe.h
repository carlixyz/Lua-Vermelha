#pragma once
#include "raylib.h"

 

enum WipeDirection { WIPE_LEFT, WIPE_RIGHT, WIPE_UP, WIPE_DOWN };

class CurtainWipe
{
public:
    RenderTexture2D Curtain{};
    Shader ShaderWipe{};
    bool Active = false;
    bool Captured = false;

    float Progress = 0.0f;
    float Duration = 1.0f;
    int EdgePx = 64;

    int Width = 0;
    int Height = 0;
    WipeDirection Dir = WIPE_LEFT;

    // Shader uniform locations
    int locProgress = -1;
    int locDir = -1;
    int locEdge = -1;

    CurtainWipe() = default;

    // Initialize with screen size and load the shader
    void Init(int width, int height)
    {
        Width = width;
        Height = height;
        Curtain = LoadRenderTexture(width, height);

        //printf("Working directory: %s\n", GetWorkingDirectory());

        ShaderWipe = LoadShader(0, "data/Shaders/curtain_wipe.fs");
        locProgress = GetShaderLocation(ShaderWipe, "progress");
        locDir = GetShaderLocation(ShaderWipe, "direction");
        locEdge = GetShaderLocation(ShaderWipe, "edgeWidth");
    }

    void Start(WipeDirection direction)
    {
        Dir = direction;
        Progress = 0.0f;
        Captured = false;
        Capture();
    }

    void Capture()
    {
        Image CaptureImg = LoadImageFromScreen();

        if (Curtain.id > 0)
            UnloadTexture(Curtain.texture);

        Curtain.texture = LoadTextureFromImage(CaptureImg);
        UnloadImage(CaptureImg);

        Active = true;
        Captured = true;
    }

    void Update(float dt)
    {
        if (!Active) return;

        Progress += dt / Duration;
        if (Progress >= 1.0f)
        {
            Progress = 1.0f;
            Active = false;
        }
    }

    void Render()
    {
        if (!Active || Curtain.texture.id == 0) return;

        float edgeNorm = (float)EdgePx / (float)Width;
        int d = (int)Dir;

        BeginShaderMode(ShaderWipe);
        SetShaderValue(ShaderWipe, locProgress, &Progress, SHADER_UNIFORM_FLOAT);
        SetShaderValue(ShaderWipe, locDir, &d, SHADER_UNIFORM_INT);
        SetShaderValue(ShaderWipe, locEdge, &edgeNorm, SHADER_UNIFORM_FLOAT);

        DrawTextureRec(Curtain.texture, { 0, 0, (float)Width, (float)Height }, { 0, 0 }, WHITE);
        EndShaderMode();
    }

    void Unload()
    {
        if (Curtain.id > 0) UnloadRenderTexture(Curtain);
        if (ShaderWipe.id > 0) UnloadShader(ShaderWipe);
    }
};

#pragma once

#include "raylib.h"
#include <string>

class QuadCaptureTool
{
public:
    static QuadCaptureTool& Get();

    bool Init();
    bool Deinit();
    void OnEnter();
    void OnExit();

    void OnUpdate(float dt);
    void OnRender();

    bool IsEnabled() const { return Enabled; }
    void Toggle();
    void Enable();
    void Disable();

private:
    QuadCaptureTool() = default;
    ~QuadCaptureTool() = default;

    QuadCaptureTool(const QuadCaptureTool&) = delete;
    QuadCaptureTool& operator=(const QuadCaptureTool&) = delete;

private:
    enum class State
    {
        Disabled,
        WaitingFirstClick,
        Dragging,
        Finished
    };

    bool Enabled = false;
    State CurrentState = State::Disabled;

    Vector2 Mouse = { 0.f, 0.f };
    Vector2 Origin = { 0.f, 0.f };
    Rectangle CurrentRect = { 0.f, 0.f, 1.f, 1.f };

    float FinishedTimer = 0.f;
    const float FinishedDuration = 3.0f;

private:
    void BeginCapture();
    void UpdateDraggingRectangle();
    void FinalizeCapture();
    void Reset();

    std::string BuildLuaSnippet() const;
};
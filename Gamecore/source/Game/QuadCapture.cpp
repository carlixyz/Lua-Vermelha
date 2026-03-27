#include "QuadCapture.h"

#include <algorithm>
#include <sstream>

QuadCaptureTool& QuadCaptureTool::Get()
{
    static QuadCaptureTool Instance;
    return Instance;
}

bool QuadCaptureTool::Init()
{
    Reset();

    return true;
}

bool QuadCaptureTool::Deinit()
{
    Reset();

    return true;
}

void QuadCaptureTool::OnEnter()
{
    // Optional: keep disabled when entering a new scene/state
    // Reset();
}

void QuadCaptureTool::OnExit()
{
    Reset();
}

void QuadCaptureTool::Toggle()
{
    if (Enabled)
        Disable();
    else
        Enable();
}

void QuadCaptureTool::Enable()
{
    Enabled = true;
    CurrentState = State::WaitingFirstClick;
    FinishedTimer = 0.f;
    CurrentRect = { 0.f, 0.f, 1.f, 1.f };
}

void QuadCaptureTool::Disable()
{
    Reset();
}

void QuadCaptureTool::Reset()
{
    Enabled = false;
    CurrentState = State::Disabled;
    Mouse = { 0.f, 0.f };
    Origin = { 0.f, 0.f };
    CurrentRect = { 0.f, 0.f, 1.f, 1.f };
    FinishedTimer = 0.f;
}

void QuadCaptureTool::BeginCapture()
{
    Origin = GetMousePosition();

    CurrentRect.x = Origin.x;
    CurrentRect.y = Origin.y;
    CurrentRect.width = 1.f;
    CurrentRect.height = 1.f;

    CurrentState = State::Dragging;
}

void QuadCaptureTool::UpdateDraggingRectangle()
{
    Mouse = GetMousePosition();

    CurrentRect.x = Origin.x;
    CurrentRect.y = Origin.y;
    CurrentRect.width = std::max(1.0f, Mouse.x - Origin.x);
    CurrentRect.height = std::max(1.0f, Mouse.y - Origin.y);
}

void QuadCaptureTool::FinalizeCapture()
{
    UpdateDraggingRectangle();

    const std::string LuaSnippet = BuildLuaSnippet();
    SetClipboardText(LuaSnippet.c_str());

    CurrentState = State::Finished;
    FinishedTimer = FinishedDuration;
}

std::string QuadCaptureTool::BuildLuaSnippet() const
{
    const int posX = static_cast<int>(CurrentRect.x);
    const int posY = static_cast<int>(CurrentRect.y);
    const int width = static_cast<int>(CurrentRect.width);
    const int height = static_cast<int>(CurrentRect.height);

    std::ostringstream ss;
    ss
        << "{ Quad = \n"
        << "    (function() \n"
        << "        local self = {}\n"
        << "        function self.OnConstruct() return { NameId = \"NewEntity\", Pos = { x = "
        << posX
        << ", y = "
        << posY
        << " }, Size = { Width = "
        << width
        << ", Height = "
        << height
        << " }} end\n"
        << "        function self.OnCommentEntry() Say(\"This is an interaction\", 3.0) Say() end\n"
        << "        function self.OnCommentLook() Say(\"This is an observation\", 3.0) Say() end\n"
        << "        function self.OnInteract() StartSequence(self.OnCommentEntry) end function self.OnLook() StartSequence(self.OnCommentLook) end \n"
        << "        return self\n"
        << "    end)()\n"
        << "},\n";

    return ss.str();
}

void QuadCaptureTool::OnUpdate(float dt)
{
    if (IsKeyPressed(KEY_R))
        Toggle();

    if (!Enabled)
        return;

    Mouse = GetMousePosition();

    switch (CurrentState)
    {
    case State::WaitingFirstClick:
    {
        if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON))
            BeginCapture();
        break;
    }

    case State::Dragging:
    {
        UpdateDraggingRectangle();

        if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON))
            FinalizeCapture();

        // Optional cancel
        if (IsMouseButtonPressed(MOUSE_RIGHT_BUTTON) || IsKeyPressed(KEY_ESCAPE))
            Disable();

        break;
    }

    case State::Finished:
    {
        FinishedTimer -= dt;
        if (FinishedTimer <= 0.f)
            Disable();

        break;
    }

    case State::Disabled:
    default:
        break;
    }
}

void QuadCaptureTool::OnRender()
{
    if (!Enabled)
        return;

    switch (CurrentState)
    {
    case State::WaitingFirstClick:
    {
        DrawCircleV(Mouse, 3.0f, GREEN);
        DrawText("Quad tool: click first corner", (int)Mouse.x + 14, (int)Mouse.y + 18, 16, GREEN);
        break;
    }

    case State::Dragging:
    {
        DrawRectangleLinesEx(CurrentRect, 2.0f, GREEN);
        DrawText(
            TextFormat("x=%d y=%d w=%d h=%d",
                (int)CurrentRect.x,
                (int)CurrentRect.y,
                (int)CurrentRect.width,
                (int)CurrentRect.height),
            (int)Mouse.x + 14,
            (int)Mouse.y + 18,
            16,
            GREEN
        );
        break;
    }

    case State::Finished:
    {
        DrawRectangleLinesEx(CurrentRect, 2.0f, BLUE);
        DrawText(
            TextFormat("Copied to clipboard: x=%d y=%d w=%d h=%d",
                (int)CurrentRect.x,
                (int)CurrentRect.y,
                (int)CurrentRect.width,
                (int)CurrentRect.height),
            (int)CurrentRect.x,
            (int)CurrentRect.y - 20,
            16,
            BLUE
        );
        break;
    }

    case State::Disabled:
    default:
        break;
    }
}
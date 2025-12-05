#pragma once

#include <raylib-cpp.hpp>
#include "../Assets.h"
#include "../../Graphics/Graphics.h"
#include "GameScene.h"

#include <functional>

class Inventory : public GameScene
{
    bool Enabled = true;

public:
    GETTERSETTER(bool, Enabled, Enabled);

    void OnInit()    override;
    void OnDeinit()  override;
    void OnUpdate(float dt) override;
    void OnRender()  override;

    void OnExit() override {}
    void OnEnter() override {}

    // Later we can inject a callback to find world entity under mouse to call OnCombine(itemId) on it.
    using WorldHitTestFn = std::function<Entity* ()>;
    void SetWorldHitTest(WorldHitTestFn fn) { WorldHitTest = std::move(fn); }

private:
    struct SlotInfo
    {
        Rectangle Area          = { 0,0,0,0 };  // where the icon is drawn in the bar
        bool     Dragging       = false;
        Vector2  DragPos        { 0,0 };        // center while dragging
        Vector2  DragOffset     { 0,0 };        // mouse - icon center at drag start

        bool     Returning      = false;        // simple tween back to slot
        float    ReturnTime     = 0.20f;
        float    ReturnElapsed  = 0.0f;
        Vector2  ReturnStart    { 0,0 };
    };

    void SyncSlotsWithEntities();
    void LayoutSlots();
    void BeginDrag(int index);
    void EndDrag(int index);
    void StartReturn(int index);

private:


    // visual config
    int   BarHeight             = 64;
    int   ItemSize              = 64;
    int   ItemGap               = 4;
    int   PaddingX              = 12;
    int   HoverThreshold        = 32;

    float SlideY                = -64.0f;
    float TargetY               = -64.0f;
    float SlideLerp             = 10.0f;

    // UI state
    std::vector<SlotInfo> Slots;
    int   HoverIndex            = -1;
    int   DragIndex             = -1;

    WorldHitTestFn WorldHitTest;  // provided by FSM/Game later
};
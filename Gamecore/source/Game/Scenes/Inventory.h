#pragma once

#include <raylib-cpp.hpp>
#include "../Assets.h"
#include "../../Graphics/Graphics.h"
#include "GameScene.h"

#include <functional>

class Inventory : public GameScene
{
public:
    void OnInit()           override;
    void OnDeinit()         override;
    void OnUpdate(float dt) override;
    void OnRender()         override;

    void OnExit()           override {}
    void OnEnter()          override {}


    // Bind the pointer FSM will keep updating
    void BindWorldScene(GameScene** currentScenePtr);

    // World hit-test callback: should return topmost world Entity under mouse,
    // or nullptr if none. Inventory will call OnCombine(itemId) on it.
    using WorldHitTestFn = std::function<Entity* ()>;
    void SetWorldHitTest(WorldHitTestFn fn) { WorldHitTest = std::move(fn); }
    int FindItemAtPoint(Vector2 mouse, int ignoreIndex = -1) const;

    // External enable/disable (for cinematics, etc.)
    void SetEnabled(bool enabled)   { Enabled = enabled; }
    bool IsEnabled() const          { return Enabled; }
    void ForceVisible(float delay)  { ForceVisibleDelay = delay; }

    void SyncSlotsWithEntities();
    void LayoutSlots();
    void OnDrag(int index);
    void OnDrop(int index);
    void StartReturn(int index);

private:
    struct SlotInfo
    {
        Rectangle Area              { 0,0,0,0 };
        bool      Dragging          = false;
        Vector2   DragPos           { 0,0 };
        Vector2   DragOffset        { 0,0 };

        bool      Returning         = false;
        float     ReturnTime        = 0.18f;
        float     ReturnElapsed     = 0.0f;
        Vector2   ReturnStart       { 0,0 };
    };

    int   PanelHeight               = 112;
    int   ItemSize                  = 64;
    int   ItemGap                   = 4;
    int   PaddingX                  = 12;
    int   HoverThreshold            = 80;   // was 32 – now "taller" and more sensible


    // Alpha-based visibility instead of sliding
    float PanelAlpha                = 0.0f;  // background gradient alpha
    float ItemsAlpha                = 0.0f;  // icons alpha
    float PanelFadeIn               = 10.0f; // panel fades faster
    float PanelFadeOut              = 8.0f;
    float ItemsFadeIn               = 6.0f;
    float ItemsFadeOut              = 5.0f;
    float ForceVisibleDelay         = 0.0f;

    std::vector<SlotInfo> Slots;
    int   HoverIndex                = -1;
    int   DragIndex                 = -1;

    bool  Enabled                   = false;

    WorldHitTestFn WorldHitTest;
};
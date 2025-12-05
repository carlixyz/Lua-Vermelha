#include "Inventory.h"
#include "Entity.h"
#include "../Game.h"
#include "../Assets.h"

//--------------------------------
void Inventory::OnInit()
{
    GameScene::OnInit();
    PanelAlpha = 0.0f;
    ItemsAlpha = 0.0f;
    HoverIndex = -1;
    DragIndex = -1;
}

//--------------------------------
void Inventory::OnDeinit()
{
    GameScene::OnDeinit();
}

//--------------------------------
void Inventory::SyncSlotsWithEntities()
{
    if (Slots.size() != Entities.size())
        Slots.resize(Entities.size());
}

//--------------------------------
void Inventory::LayoutSlots()
{
    SyncSlotsWithEntities();

    int x = PaddingX;
    int y = 8;  // <-- icons start 8px from the very top of the screen

    const size_t count = Entities.size();
    for (size_t i = 0; i < count; ++i)
    {
        SlotInfo& slot = Slots[i];

        // This rectangle is the clickable area AND the visual “slot” area
        slot.Area = Rectangle{
            (float)x,
            (float)y,
            (float)ItemSize,   // e.g. 64
            (float)ItemSize
        };

        // If not dragging or returning, keep DragPos at the center of Area
        if (!slot.Dragging && !slot.Returning)
        {
            slot.DragPos.x = slot.Area.x + slot.Area.width * 0.5f;
            slot.DragPos.y = slot.Area.y + slot.Area.height * 0.5f;
        }

        x += ItemSize + ItemGap;
    }
}


//--------------------------------
void Inventory::BeginDrag(int index)
{
    DragIndex = index;
    SlotInfo& slot = Slots[index];
    slot.Dragging = true;
    slot.Returning = false;
    slot.ReturnElapsed = 0.0f;

    const Vector2 mouse = GetMousePosition();
    slot.DragOffset = {
        mouse.x - slot.DragPos.x,
        mouse.y - slot.DragPos.y
    };
}

//--------------------------------
void Inventory::StartReturn(int index)
{
    SlotInfo& slot = Slots[index];
    slot.Dragging = false;
    slot.Returning = true;
    slot.ReturnElapsed = 0.0f;
    slot.ReturnStart = slot.DragPos;
}

//--------------------------------
void Inventory::EndDrag(int index)
{
    SlotInfo& slot = Slots[index];

    Entity* worldTarget = nullptr;
    if (WorldHitTest) worldTarget = WorldHitTest();

    if (worldTarget && Entities[index])
    {
        const std::string& itemId = Entities[index]->GetInfo().NameId;
        worldTarget->OnCombine(itemId);

        // For now, keep item and snap it back visibly
        StartReturn(index);
    }
    else
    {
        // Dropped on empty space -> snap back
        StartReturn(index);
    }

    DragIndex = -1;
}

//--------------------------------
void Inventory::OnUpdate(float dt)
{
    // If disabled (e.g. cinematic), fade everything out and ignore input
    if (!Enabled)
    {
        PanelAlpha = 0.0f;
        ItemsAlpha = 0.0f;
        HoverIndex = -1;
        DragIndex = -1;
        return;
    }

    const Vector2 mouse = GetMousePosition();
    const float   mouseY = mouse.y;

    const bool hoverTop = (mouseY < (float)HoverThreshold);

    const float panelDelta = (hoverTop ? PanelFadeIn : -PanelFadeOut) * dt;
    const float itemsDelta = (hoverTop ? ItemsFadeIn : -ItemsFadeOut) * dt;

    PanelAlpha = Clamp(PanelAlpha + panelDelta, 0.0f, 1.0f);
    ItemsAlpha = Clamp(ItemsAlpha + itemsDelta, 0.0f, 1.0f);

    LayoutSlots();

    HoverIndex = -1;
    const int entityCount = (int)Entities.size();

    if (ItemsAlpha > 0.05f)
    {
        for (int i = entityCount - 1; i >= 0; --i)
        {
            if (CheckCollisionPointRec(mouse, Slots[i].Area))
            {
                HoverIndex = i;
                break;
            }
        }
    }

    if (ItemsAlpha > 0.1f &&
        IsMouseButtonPressed(MOUSE_LEFT_BUTTON) &&
        HoverIndex != -1 &&
        DragIndex == -1)
    {
        BeginDrag(HoverIndex);
    }

    if (DragIndex != -1)
    {
        SlotInfo& slot = Slots[DragIndex];
        if (slot.Dragging)
        {
            slot.DragPos.x = mouse.x - slot.DragOffset.x;
            slot.DragPos.y = mouse.y - slot.DragOffset.y;

            if (IsMouseButtonReleased(MOUSE_LEFT_BUTTON))
                EndDrag(DragIndex);
        }
    }

    const size_t slotCount = Slots.size();
    for (size_t i = 0; i < slotCount; ++i)
    {
        SlotInfo& slot = Slots[i];
        if (!slot.Returning) continue;

        slot.ReturnElapsed += dt;
        float t = slot.ReturnElapsed / slot.ReturnTime;

        const float cx = slot.Area.x + slot.Area.width * 0.5f;
        const float cy = slot.Area.y + slot.Area.height * 0.5f;

        if (t >= 1.0f)
        {
            slot.DragPos.x = cx;
            slot.DragPos.y = cy;
            slot.Returning = false;
        }
        else
        {
            const float oneMinusT = 1.0f - t;
            const float u = 1.0f - oneMinusT * oneMinusT * oneMinusT;

            slot.DragPos.x = slot.ReturnStart.x + (cx - slot.ReturnStart.x) * u;
            slot.DragPos.y = slot.ReturnStart.y + (cy - slot.ReturnStart.y) * u;
        }
    }

    GameScene::OnUpdate(dt);
}


//--------------------------------
void Inventory::OnRender()
{
    if (!Enabled)
        return;

    const Vector2 mouse = GetMousePosition();
    const float   mouseY = mouse.y;
    const int     screenW = GetScreenWidth();
    const int     entityCount = (int)Entities.size();

    // If nothing is visible AND nothing is being dragged/returned, skip
    bool anyReturning = false;
    for (const SlotInfo& s : Slots)
        if (s.Returning) { anyReturning = true; break; }

    const bool panelVisible = (PanelAlpha > 0.01f);
    const bool itemsVisible = (ItemsAlpha > 0.01f);

    if (!panelVisible && !itemsVisible && DragIndex == -1 && !anyReturning)
        return;

    // -------------------------------
    // Background gradient: top->bottom
    // -------------------------------
    Color topColor = ColorAlpha(BLACK, PanelAlpha);
    Color bottomColor = ColorAlpha(BLACK, 0.0f);

    DrawRectangleGradientV(
        0, 0, screenW, PanelHeight,
        topColor, bottomColor
    );

    // -------------------------------
    // Icons
    // -------------------------------
    for (int i = 0; i < entityCount; ++i)
    {
        Entity* e = Entities[i];
        if (!e) continue;

        const SlotInfo& slot = Slots[i];
        Texture2D& tex = e->GetSprite();
        if (!IsTextureValid(tex)) continue;

        const Vector2 center = slot.DragPos;

        Rectangle dst = {
            center.x - slot.Area.width * 0.5f,
            center.y - slot.Area.height * 0.5f,
            slot.Area.width,
            slot.Area.height
        };

        const Rectangle src = {
            0.0f, 0.0f,
            (float)tex.width,
            (float)tex.height
        };

        // Dragged or returning icons ignore ItemsAlpha and stay fully visible.
        float iconAlphaFactor = 1.0f;
        if (i != DragIndex && !slot.Returning)
        {
            iconAlphaFactor = ItemsAlpha;
        }

        if (iconAlphaFactor <= 0.01f)
            continue; // completely invisible, skip

        DrawTexturePro(
            tex, src, dst, { 0,0 }, 0.0f,
            ColorAlpha(WHITE, e->GetInfo().Alpha * iconAlphaFactor)
        );
    }

    // -------------------------------
    // Cursor & label for inventory zone only
    // -------------------------------
    const float panelTop = 0.0f;
    const float panelBottom = (float)PanelHeight;

    int labelIndex = -1;
    if (DragIndex != -1)       labelIndex = DragIndex;
    else if (HoverIndex != -1) labelIndex = HoverIndex;

    const bool mouseInPanel = (mouseY >= panelTop && mouseY <= panelBottom);
    const bool uiVisible = (PanelAlpha > 0.05f || ItemsAlpha > 0.05f || DragIndex != -1 || anyReturning);

    if (uiVisible && mouseInPanel)
    {
        if (labelIndex >= 0 && labelIndex < entityCount && Entities[labelIndex])
        {
            DrawTexture(GetTexture("MB"), (int)mouse.x, (int)mouse.y, WHITE);

            DrawTextEx(
                GetFont("Noto"),
                Entities[labelIndex]->GetInfo().NameId.c_str(),
                { mouse.x + 12.0f, mouse.y + 24.0f },
                16.0f, 1.0f, WHITE
            );
        }
        else
        {
            DrawTexture(GetTexture("MA"), (int)mouse.x, (int)mouse.y, WHITE);
        }
    }
    // Outside panel, Inventory draws nothing; world cursor logic stays in charge.
}


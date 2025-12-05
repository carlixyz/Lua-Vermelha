#include "Inventory.h"
#include "Entity.h"
#include "../Game.h"
#include "../Assets.h"

//--------------------------------
void Inventory::OnInit()
{
    GameScene::OnInit();
    SlideY = -(float)BarHeight;
    TargetY = SlideY;
}

//--------------------------------
void Inventory::OnDeinit()
{
    // Entities are owned by GameScene; FSM will handle deleting scenes
    GameScene::OnDeinit();
}

//--------------------------------
// Make sure Slots array matches Entities size
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
    int y = (int)SlideY + (BarHeight - ItemSize) / 2;

    for (size_t i = 0; i < Entities.size(); ++i)
    {
        Slots[i].Area = Rectangle{ (float)x, (float)y, (float)ItemSize, (float)ItemSize };

        // If not dragging and not returning, keep drag position at center of slot
        if (!Slots[i].Dragging && !Slots[i].Returning) {
            float cx = Slots[i].Area.x + Slots[i].Area.width * 0.5f;
            float cy = Slots[i].Area.y + Slots[i].Area.height * 0.5f;
            Slots[i].DragPos = { cx, cy };
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

    Vector2 mouse = GetMousePosition();
    slot.DragOffset = { mouse.x - slot.DragPos.x, mouse.y - slot.DragPos.y };
}

//--------------------------------
void Inventory::StartReturn(int index)
{
    SlotInfo& slot = Slots[index];
    slot.Dragging = false;
    slot.Returning = true;
    slot.ReturnElapsed = 0.0f;
    slot.ReturnStart = slot.DragPos; // start from current dragged pos
}

//--------------------------------
void Inventory::EndDrag(int index)
{
    SlotInfo& slot = Slots[index];

    Entity* worldTarget = nullptr;
    if (WorldHitTest) worldTarget = WorldHitTest();

    if (worldTarget && Entities[index])
    {
        // Use the Entity NameId as logical item id
        const std::string& itemId = Entities[index]->GetInfo().NameId;
        worldTarget->OnCombine(itemId);

        // For now, still keep item in inventory and snap it back
        StartReturn(index);

        // OPTIONAL: if the item should be consumed, you might do:
        // FSM::Get().ChangeEntityScene(itemId, /*some scene or remove logic*/);
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
    if (!GetEnabled())
        return;

    // Cache mouse once
    const Vector2 mouse = GetMousePosition();

    // Slide open/close by mouse at top
    const bool hoverTop = (mouse.y < (float)HoverThreshold);
    TargetY = hoverTop ? 0.0f : -(float)BarHeight;
    SlideY = Lerp(SlideY, TargetY, dt * SlideLerp);

    // Layout item slots according to current slide
    LayoutSlots();

    // Hover detection (if visible enough)
    HoverIndex = -1;
    const int entityCount = (int)Entities.size();

    if (SlideY > -BarHeight * 0.6f)
    {
        // from topmost to bottom (reverse order, same as before)
        for (int i = entityCount - 1; i >= 0; --i)
        {
            if (CheckCollisionPointRec(mouse, Slots[i].Area))
            {
                HoverIndex = i;
                break;
            }
        }
    }

    // Drag begin
    if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON) &&
        HoverIndex != -1 &&
        DragIndex == -1)
    {
        BeginDrag(HoverIndex);
    }

    // Drag update
    if (DragIndex != -1)
    {
        SlotInfo& slot = Slots[DragIndex];
        if (slot.Dragging)
        {
            // reuse cached mouse
            slot.DragPos = {
                mouse.x - slot.DragOffset.x,
                mouse.y - slot.DragOffset.y
            };

            if (IsMouseButtonReleased(MOUSE_LEFT_BUTTON))
                EndDrag(DragIndex);
        }
    }

    // Return tween
    const size_t slotCount = Slots.size();
    for (size_t i = 0; i < slotCount; ++i)
    {
        SlotInfo& slot = Slots[i];
        if (slot.Returning)
        {
            slot.ReturnElapsed += dt;
            float t = slot.ReturnElapsed / slot.ReturnTime;

            if (t >= 1.0f)
            {
                // snap to slot center
                const float cx = slot.Area.x + slot.Area.width * 0.5f;
                const float cy = slot.Area.y + slot.Area.height * 0.5f;
                slot.DragPos = { cx, cy };
                slot.Returning = false;
            }
            else
            {
                // simple cubic ease-out
                const float oneMinusT = 1.0f - t;
                const float u = 1.0f - oneMinusT * oneMinusT * oneMinusT;

                const float cx = slot.Area.x + slot.Area.width * 0.5f;
                const float cy = slot.Area.y + slot.Area.height * 0.5f;

                slot.DragPos.x = slot.ReturnStart.x + (cx - slot.ReturnStart.x) * u;
                slot.DragPos.y = slot.ReturnStart.y + (cy - slot.ReturnStart.y) * u;
            }
        }
    }

    // Let GameScene tick entities (tweens, alpha, etc.)
    GameScene::OnUpdate(dt);
}


//--------------------------------
void Inventory::OnRender()
{
    if (!GetEnabled())
        return;

    // Cache common values once
    const Vector2 mouse  = GetMousePosition();
    const int     screenW = GetScreenWidth();
    const int     entityCount = (int)Entities.size();

    // Background bar
    DrawRectangle(0, (int)SlideY, screenW, BarHeight, ColorAlpha(BLACK, 0.75f));
    DrawLine(0, (int)(SlideY + BarHeight - 1),
             screenW, (int)(SlideY + BarHeight - 1),
             Fade(RAYWHITE, 0.25f));

    // Draw each entity as a 64x64 icon in its slot
    for (int i = 0; i < entityCount; ++i)
    {
        Entity* e = Entities[i];
        if (!e) continue;

        const SlotInfo& slot = Slots[i];
        Texture2D& tex = e->GetSprite();
        if (!IsTextureValid(tex)) continue;

        // slot frame
        const Color frame =
            (HoverIndex == i) ? Fade(YELLOW, 0.9f) : Fade(RAYWHITE, 0.25f);
        DrawRectangleLinesEx(slot.Area, 1.0f, frame);

        // choose center (DragPos handles normal + returning + dragging)
        const Vector2 center = slot.DragPos;

        Rectangle dst = {
            center.x - slot.Area.width  * 0.5f,
            center.y - slot.Area.height * 0.5f,
            slot.Area.width,
            slot.Area.height
        };

        const Rectangle src = {
            0.0f, 0.0f,
            (float)tex.width,
            (float)tex.height
        };

        DrawTexturePro(tex, src, dst, {0,0}, 0.0f,
                       ColorAlpha(WHITE, e->GetInfo().Alpha));
    }

    // ---------------------------------------------
    //  Cursor & label rendering for inventory area
    // ---------------------------------------------
    const float barTop    = SlideY;
    const float barBottom = SlideY + BarHeight;

    // Determine which item name to show (drag has priority)
    int labelIndex = -1;
    if (DragIndex != -1)       labelIndex = DragIndex;
    else if (HoverIndex != -1) labelIndex = HoverIndex;

    const bool barVisible = (SlideY > -BarHeight + 1.0f);
    const bool mouseInBar = (mouse.y >= barTop && mouse.y <= barBottom);

    if (barVisible && mouseInBar)
    {
        if (labelIndex >= 0 && labelIndex < entityCount && Entities[labelIndex])
        {
            // Hovering/dragging an inventory item
            DrawTexture(GetTexture("MB"), (int)mouse.x, (int)mouse.y, WHITE);

            DrawTextEx(GetFont("Noto"),
                       Entities[labelIndex]->GetInfo().NameId.c_str(),
                       { mouse.x + 12.0f, mouse.y + 24.0f },
                       16.0f, 1.0f, WHITE);
        }
        else
        {
            // Over the bar but not on an item -> basic cursor
            DrawTexture(GetTexture("MA"), (int)mouse.x, (int)mouse.y, WHITE);
        }
    }

    // Outside the bar, Inventory draws no cursor;
    // world scenes' Entity::OnRender() keep full control.
}


#include "Entity.h"
#include "../Assets.h"
#include "../Director.h"
#include "../Game.h"
#include <raylib-cpp.hpp>
#include <filesystem>
#include "SceneFactory.h"

void EntityLua::OnReturn()
{
    // Subclasses override this to handle optional return values
    if (!lua_istable(LuaContext, -1))
    {
        lua_pop(LuaContext, 1);
        return;
    }

    // --------- Optional fields ---------
    lua_getfield(LuaContext, -1, "NameId");
    if (lua_isstring(LuaContext, -1))
        Info.NameId = lua_tostring(LuaContext, -1);
    lua_pop(LuaContext, 1);

    lua_getfield(LuaContext, -1, "NameView");
    if (lua_isstring(LuaContext, -1))
        Info.NameView = lua_tostring(LuaContext, -1);
    lua_pop(LuaContext, 1);

    if (Info.NameView.empty())
        Info.NameView = Info.NameId; // If NameView is missing just use NameId as fallback

    lua_getfield(LuaContext, -1, "Cursor");
    if (lua_isstring(LuaContext, -1))
        Info.CustomCursor = lua_tostring(LuaContext, -1);
    lua_pop(LuaContext, 1);

    //lua_getfield(LuaContext, -1, "NextScene");
    //if (lua_isstring(LuaContext, -1)) SceneTarget = lua_tostring(LuaContext, -1);
    //lua_pop(LuaContext, 1);

    lua_getfield(LuaContext, -1, "Visible");
    if (lua_isboolean(LuaContext, -1)) 
        Info.Visible = lua_toboolean(LuaContext, -1);
    lua_pop(LuaContext, 1);

    lua_getfield(LuaContext, -1, "Active");
    if (lua_isboolean(LuaContext, -1))
        Info.Active = lua_toboolean(LuaContext, -1);
    lua_pop(LuaContext, 1);

    // Get Textures table
    lua_getfield(LuaContext, -1, "Textures");

    if (lua_istable(LuaContext, -1))
    {
        // Lambda to load all string string pairs in the current table
        auto loadFlatTable = [&](int tableIndex)
        {
            for (lua_pushnil(LuaContext); lua_next(LuaContext, tableIndex); lua_pop(LuaContext, 1))
                if (lua_isstring(LuaContext, -2) && lua_isstring(LuaContext, -1))
                {
                    std::string name = lua_tostring(LuaContext, -2);
                    std::string path = lua_tostring(LuaContext, -1);
                    Assets::Get().LoadTextureID(name, path);
                    Info.TexturesIDs.push_back(name);
                }
        };

        // Peek to decide which format we're in
        lua_pushnil(LuaContext);

        // --- Single flat table ---
        if (lua_next(LuaContext, -2) != 0 && lua_isstring(LuaContext, -2) && lua_isstring(LuaContext, -1))
        {
            lua_pop(LuaContext, 2); // pop key + value

            loadFlatTable(lua_gettop(LuaContext)); // process directly
        }
        else // --- Multiple nested tables (default) ---
        {
            lua_pop(LuaContext, 2); // pop key + value

            for (lua_pushnil(LuaContext); lua_next(LuaContext, -2); lua_pop(LuaContext, 1))
                if (lua_istable(LuaContext, -1))
                    loadFlatTable(lua_gettop(LuaContext)); // process each inner table
        }
    }
    else if (lua_isstring(LuaContext, -1))          // LAZY texture designation I.Ex.: Textures = "data/Scenes/Inventory/BrokenPhone.png"
    {
        //std::string name = Info.NameId;
        std::string path = lua_tostring(LuaContext, -1);

        // if for some reason We don't have an actual name ID then use the image file as the texture ID
        //std::string name = !Info.NameId.empty() ? Info.NameId : std::filesystem::path(path).stem().string();
        std::string name = std::filesystem::path(path).stem().string();

        Assets::Get().LoadTextureID(name, path);
        Info.TexturesIDs.push_back(name);
    }

    lua_pop(LuaContext, 1); // pop Textures


    // Get CurrentImage (by first key reference)
    std::string CurrentID = !Info.TexturesIDs.empty() ? Info.TexturesIDs[0] : "";

    lua_getfield(LuaContext, -1, "CurrentImage");
    if (lua_isstring(LuaContext, -1))
        CurrentID = lua_tostring(LuaContext, -1);
    lua_pop(LuaContext, 1);

    if (!CurrentID.empty())
        SetSprite(CurrentID);

    auto ReadPositionField = [&](const char* fieldName) -> bool
    {
        lua_getfield(LuaContext, -1, fieldName);

        if (!lua_istable(LuaContext, -1))
        {
            lua_pop(LuaContext, 1);
            return false;
        }

        lua_getfield(LuaContext, -1, "x");
        if (lua_isnumber(LuaContext, -1))
            Info.PositionX = (int)lua_tonumber(LuaContext, -1);
        lua_pop(LuaContext, 1);

        lua_getfield(LuaContext, -1, "y");
        if (lua_isnumber(LuaContext, -1))
            Info.PositionY = (int)lua_tonumber(LuaContext, -1);
        lua_pop(LuaContext, 1);

        lua_pop(LuaContext, 1); // pop Position/Pos table
        return true;
    };


    if (!ReadPositionField("Position") && !ReadPositionField("Pos"))  // if (Info.PositionX == 0 && Info.PositionY == 0)
        Info.Clickable = false;

    lua_getfield(LuaContext, -1, "Clickable"); // explicit Clickable has priority
    if (lua_isboolean(LuaContext, -1))
        Info.Clickable = lua_toboolean(LuaContext, -1);
    lua_pop(LuaContext, 1);

    lua_getfield(LuaContext, -1, "Alpha");
    if (lua_isnumber(LuaContext, -1)) 
        Info.Alpha = (float)lua_tonumber(LuaContext, -1);
    lua_pop(LuaContext, 1);
}

void Entity::Debug()
{
    if (Game::Get().IsDebugMode())
        DrawRectangleLines(Info.PositionX, Info.PositionY, CurrentSprite.width, CurrentSprite.height, RED);
}

void Entity::SetSprite(const std::string& textureID)
{
    if (Assets::Get().HasTextureID(textureID))
    {
        CurrentSprite = Assets::Get().GetTexture(textureID);
        Mask.BuildAlphaMask(CurrentSprite);
    }
    else
        std::cout << "texture '" << textureID << "' NOT FOUND for entity: '" << Info.NameId << "'\n";
}

void Entity::OnInit()
{
}

void Entity::OnDeinit()
{
    for (const std::string& textID : Info.TexturesIDs)
        Assets::Get().UnloadTextureID(textID);

    Info.TexturesIDs.clear();
    Mask.Opaque.clear();
    CurrentSprite = Texture2D{};
}

void Entity::OnUpdate(float deltaTime)
{
    tween.Update(deltaTime);

    bool LeftButtonClick = IsMouseButtonPressed(MOUSE_LEFT_BUTTON);
    bool RightButtonClick = IsMouseButtonPressed(MOUSE_RIGHT_BUTTON);

    //if (GetIsActive())
    //    Call("OnUpdate");

    if (LeftButtonClick || RightButtonClick) // || GetKeyPressed() > 0)
        OnScreenInput();

    if (!GetIsClickable())
        return;

    if (Hovered = IsMouseOver())
        if (!LuaManager::Get().IsSequenceRunning())
        {
            if (LeftButtonClick)
                OnInteract();

            if (RightButtonClick)
                OnLook();
        }
}

void Entity::OnRender()
{
    if (IsTextureValid(CurrentSprite))
        DrawTexture(CurrentSprite, Info.PositionX, Info.PositionY, ColorAlpha(WHITE, Info.Alpha)); //Fade(WHITE, Info.Alpha));

    if (Game::Get().IsDebugMode())
        Debug(); //DrawRectangle(Info.PositionX, Info.PositionY, CurrentSprite.width, CurrentSprite.height, ColorAlpha(RED, 0.1f));

    // --- Hover feedback ---
    if (!GetIsClickable() || !GetIsHovered()) 
        return;

    if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON) || IsMouseButtonPressed(MOUSE_RIGHT_BUTTON) )
        highlightLapse = 0.1f;

    if (highlightLapse > 0.f /*&& IsTextureValid(CurrentSprite)*/)
    {
        highlightLapse -= GetFrameTime();
        BeginBlendMode(BLEND_ADDITIVE);
        DrawTexture(CurrentSprite, Info.PositionX, Info.PositionY, Fade(WHITE, 0.25f));
        EndBlendMode();
    }
    //else if (highlightLapse > 0.f) highlightLapse -= GetFrameTime();

    /*
    //DrawTexture( GetTexture("MB"), (int)MouseCursor.x, (int)MouseCursor.y, WHITE);
    Vector2 MouseCursor = GetMousePosition();

    DrawTextEx(GetFont("Noto"), Info.NameView.c_str(), { MouseCursor.x + 12, MouseCursor.y + 24 }, 16, 1.0f, WHITE);
    */
}

bool Entity::IsMouseOver()
{
    return Mask.IsOpaque(
        (int)GetMouseX() - Info.PositionX,
        (int)GetMouseY() - Info.PositionY);
}

void Quad::OnReturn()
{
    EntityLua::OnReturn();

    lua_getfield(LuaContext, -1, "Size");
    if (lua_istable(LuaContext, -1)) {
        lua_getfield(LuaContext, -1, "Width");
        if (lua_isnumber(LuaContext, -1)) HitBox.width = (float)lua_tonumber(LuaContext, -1);
        lua_pop(LuaContext, 1);

        lua_getfield(LuaContext, -1, "Height");
        if (lua_isnumber(LuaContext, -1)) HitBox.height = (float)lua_tonumber(LuaContext, -1);
        lua_pop(LuaContext, 1);
    }
    lua_pop(LuaContext, 1);
}

bool Quad::IsMouseOver()
{
    Vector2 mouse = GetMousePosition();

    Rectangle HitRect = {
    (float)Info.PositionX,
    (float)Info.PositionY,
    HitBox.width,
    HitBox.height };

    return CheckCollisionPointRec(mouse, HitRect);
}

void Quad::Debug()
{
    DrawRectangleLines(Info.PositionX, Info.PositionY, (int)HitBox.width, (int)HitBox.height, RED);
}

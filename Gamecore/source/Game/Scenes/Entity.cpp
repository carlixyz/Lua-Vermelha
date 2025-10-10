#include "Entity.h"
#include "../Assets.h"
#include "../Director.h"

void Entity::OnReturn()
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
    {
        Info.NameId = lua_tostring(LuaContext, -1);
        Director::Get().RegisterEntity(this);
    }
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

    lua_getfield(LuaContext, -1, "Clickable");
    if (lua_isboolean(LuaContext, -1))
        Info.Clickable = lua_toboolean(LuaContext, -1);
    lua_pop(LuaContext, 1);

    // Get Textures table
    lua_getfield(LuaContext, -1, "Textures");
    if (lua_istable(LuaContext, -1)) 
    {
        for (lua_pushnil(LuaContext); lua_next(LuaContext, -2); lua_pop(LuaContext, 1))
        {
            if (!lua_istable(LuaContext, -1)) continue;

            for (lua_pushnil(LuaContext); lua_next(LuaContext, -2); lua_pop(LuaContext, 1))
            {
                if (lua_isstring(LuaContext, -2) && lua_isstring(LuaContext, -1)) {
                    std::string nameID = lua_tostring(LuaContext, -2);
                    std::string texturePath = lua_tostring(LuaContext, -1);
                    Assets::Get().LoadTextureID(nameID, texturePath);
                    Info.TexturesIDs.push_back(nameID); // optional list
                }
            }
        }
    }
    lua_pop(LuaContext, 1);

    // Get CurrentImage (by key reference)
    lua_getfield(LuaContext, -1, "CurrentImage");
    if (lua_isstring(LuaContext, -1))
    {
        const std::string textureID = lua_tostring(LuaContext, -1);
        if (!textureID.empty())
            SetSprite(textureID);
    }
    lua_pop(LuaContext, 1);

    lua_getfield(LuaContext, -1, "Position");
    if (lua_istable(LuaContext, -1)) {
        lua_getfield(LuaContext, -1, "x");
        if (lua_isnumber(LuaContext, -1)) Info.PositionX = (int)lua_tonumber(LuaContext, -1);
        lua_pop(LuaContext, 1);

        lua_getfield(LuaContext, -1, "y");
        if (lua_isnumber(LuaContext, -1)) Info.PositionY = (int)lua_tonumber(LuaContext, -1);
        lua_pop(LuaContext, 1);
    }
    lua_pop(LuaContext, 1);

    lua_getfield(LuaContext, -1, "Alpha");
    if (lua_isnumber(LuaContext, -1)) 
        Info.Alpha = (float)lua_tonumber(LuaContext, -1);
    lua_pop(LuaContext, 1);

    //lua_pop(LuaContext, 1);
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
	Call("OnInit");
    std::cout << "Created base Entity: " << Info.NameId << std::endl;
}

void Entity::OnDeinit()
{
	Call("OnDeinit");

    for (const std::string& textID : Info.TexturesIDs)
    {
        Assets::Get().UnloadTextureID(textID);
    }

    Info.TexturesIDs.clear();

    Mask.Opaque.clear();
}

void Entity::OnUpdate()
{
    //if (GetIsActive())
    //    Call("OnUpdate");

    if (!GetIsClickable()) 
        return;

    if (Hovered = IsMouseOver())
    {
        if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON))
        {
            OnInteract();
        }

        if (IsMouseButtonPressed(MOUSE_RIGHT_BUTTON))
        {
            OnLook();
        }
    }
}

void Entity::OnRender()
{
    DrawTexture(CurrentSprite, Info.PositionX, Info.PositionY, WHITE);

    if (debug)
        DrawRectangle(Info.PositionX, Info.PositionY, CurrentSprite.width, CurrentSprite.height, ColorAlpha(RED, 0.05f));

    // --- Hover feedback ---
    if (!GetIsHovered()) 
        return;

    if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON) || IsMouseButtonReleased(MOUSE_RIGHT_BUTTON) )
        highlightLapse = 0.1f;

    if (highlightLapse > 0.f)
    {
        highlightLapse -= GetFrameTime();
        BeginBlendMode(BLEND_ADDITIVE);
        DrawTexture(CurrentSprite, Info.PositionX, Info.PositionY, Fade(WHITE, 0.25f));
        EndBlendMode();
    }

	//DrawRectangleLines(Info.PositionX, Info.PositionY, CurrentSprite.width, CurrentSprite.height, WHITE);
    DrawText(Info.NameId.c_str(), Info.PositionX + 4, Info.PositionY - 16, 10, WHITE);
    //DrawRectangle(Info.PositionX, Info.PositionY, CurrentSprite.width, CurrentSprite.height, ColorAlpha(WHITE, 0.05f));
}

void Entity::OnInteract()
{
	Call("OnInteract");
}

void Entity::OnLook()
{
	Call("OnLook");
}

void Entity::OnCombine(const std::string& itemId)
{
	Call("OnCombine");
}

bool Entity::IsMouseOver() const
{
    //Vector2 mouse = GetMousePosition();
    //Rectangle SpriteRect = {
    //(float)Info.PositionX,
    //(float)Info.PositionY,
    //CurrentSprite.width,
    //CurrentSprite.height };
    //return CheckCollisionPointRec(mouse, SpriteRect);

    int localX = GetMouseX() - Info.PositionX;
    int localY = GetMouseY() - Info.PositionY;

    return Mask.IsOpaque(localX, localY);
}

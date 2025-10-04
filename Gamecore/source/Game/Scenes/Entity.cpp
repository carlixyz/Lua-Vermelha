#include "Entity.h"

void Entity::OnReturn()
{
    // Subclasses override this to handle optional return values
    if (!lua_istable(LuaContext, -1))
    {
        //lua_pop(LuaContext, 1);
        return;
    }

    // --------- Optional fields ---------
    lua_getfield(LuaContext, -1, "NameId");
    if (lua_isstring(LuaContext, -1)) Info.NameId = lua_tostring(LuaContext, -1);
    lua_pop(LuaContext, 1);

    //lua_getfield(LuaContext, -1, "NextScene");
    //if (lua_isstring(LuaContext, -1)) SceneTarget = lua_tostring(LuaContext, -1);
    //lua_pop(LuaContext, 1);

    lua_getfield(LuaContext, -1, "Visible");
    if (lua_isboolean(LuaContext, -1)) Info.Visible = lua_toboolean(LuaContext, -1);
    lua_pop(LuaContext, 1);

    lua_getfield(LuaContext, -1, "Textures");
    if (lua_istable(LuaContext, -1)) {
        lua_pushnil(LuaContext);
        while (lua_next(LuaContext, -2) != 0) {
            if (lua_isstring(LuaContext, -1))
                Info.TexturesIDs.push_back(lua_tostring(LuaContext, -1));
            lua_pop(LuaContext, 1);
        }
    }
    lua_pop(LuaContext, 1);

    //lua_getfield(LuaContext, -1, "CurrentTexture");
    //if (lua_isstring(LuaContext, -1)) CurrentSprite = lua_tostring(LuaContext, -1);
    //lua_pop(LuaContext, 1);

    lua_getfield(LuaContext, -1, "Position");
    if (lua_istable(LuaContext, -1)) {
        lua_getfield(LuaContext, -1, "x");
        if (lua_isnumber(LuaContext, -1)) Info.PositionX = (float)lua_tonumber(LuaContext, -1);
        lua_pop(LuaContext, 1);

        lua_getfield(LuaContext, -1, "y");
        if (lua_isnumber(LuaContext, -1)) Info.PositionY = (float)lua_tonumber(LuaContext, -1);
        lua_pop(LuaContext, 1);
    }
    lua_pop(LuaContext, 1);

    lua_getfield(LuaContext, -1, "Alpha");
    if (lua_isnumber(LuaContext, -1)) Info.Alpha = (float)lua_tonumber(LuaContext, -1);
    lua_pop(LuaContext, 1);

    //lua_pop(LuaContext, 1);
}

void Entity::OnInit()
{
	Call("OnInit");
}

void Entity::OnDeinit()
{
	Call("OnDeinit");

}

void Entity::OnUpdate()
{
}

void Entity::OnRender()
{
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

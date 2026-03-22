#pragma once

#include "InstanceBase.h"
#include "LuaInterface.h"
#include "Sprite.h"

#include <iostream>
#include <string>
#include <raylib-cpp.hpp>

/*
struct SpriteInfo
{
	std::string	NameId;
	bool Visible = false;
	bool Active = true;
	bool Clickable = true;

	int PositionX = 0;
	int PositionY = 0;
	float Alpha = 1.f;

	Rectangle Size = { 0.0f, 0.0f, 1.0f, 1.0f };
	std::vector<std::string> TexturesIDs;
};
*/


class Entity : public InstanceBase
{
protected:

	SpriteInfo Info;
	Tween tween { this->Info };
	Texture2D CurrentSprite;
	AlphaMask Mask;

	bool Hovered = false;

	float highlightLapse = 0.f;

	friend class FSM;
	friend class Assets;

	virtual void Debug();

public:

	inline const std::string& GetID()	{ return Info.NameId; }
	inline SpriteInfo& GetInfo()		{ return Info; }
	inline Texture2D& GetSprite()		{ return CurrentSprite; }
	inline Tween& GetTween()			{ return tween; }

	void SetSprite(const std::string& textureID);

	virtual bool IsMouseOver();

	GETTERSETTER(bool, IsVisible, Info.Visible)
	GETTERSETTER(bool, IsActive, Info.Active)
	GETTERSETTER(bool, IsClickable, Info.Clickable)
	GETTERSETTER(bool, IsHovered, Hovered)
	GETTERSETTER(int, PositionX, Info.PositionX )
	GETTERSETTER(int, PositionY, Info.PositionY )
	GETTERSETTER(float, Alpha, Info.Alpha)
 
 
	virtual void OnInit()	override;
	virtual void OnDeinit()	override;
	virtual void OnUpdate(float deltaTime) override;
	virtual void OnRender()	override;

	virtual void OnScreenInput()						{ ; }
	virtual void OnInteract()							{ ; }
	virtual void OnLook()								{ ; }
	virtual void OnCombine(const std::string& itemId)	{ ; }
};


class EntityLua : public Entity, public LuaInterface
{
protected:
	virtual void OnReturn() override;

public:
	EntityLua(const std::string& scriptPath) : LuaInterface(scriptPath) { Call("OnConstruct"); }

	EntityLua(int tableIndex) : LuaInterface(tableIndex) { Call("OnConstruct"); }

	virtual void OnInit() override								{ Entity::OnInit(); Call("OnInit"); }
	virtual void OnDeinit() override							{ Call("OnDeinit"); Entity::OnDeinit(); }

	//virtual void OnRender() override							{ Entity::OnRender(); Call("OnRender"); }

	virtual void OnEnter() override								{ Entity::OnInit();Call("OnEnter"); }
	virtual void OnExit()	override							{ Call("OnExit"); }

	virtual void OnScreenInput() override						{ Call("OnScreenInput"); }
	virtual void OnInteract() override							{ Call("OnInteract"); }

	virtual void OnLook() override								{ Call("OnLook"); }
	virtual void OnCombine(const std::string& itemId) override	{ Call("OnCombine", itemId); highlightLapse = 0.1f; }
};


class Quad : public EntityLua // Gates are just like Doors but with a simplified collision box
{
	Rectangle HitBox;// = { 0, 0, 30, GetScreenHeight() };

	virtual void OnReturn() override;

public:
	Quad(const std::string& scriptPath) :
		EntityLua(scriptPath), 
		HitBox(0, 0, (float)50, (float)GetScreenHeight())
	{ Call("OnConstruct"); }

	Quad(int tableIndex) :
		EntityLua(tableIndex),
		HitBox(0, 0, (float)50, (float)GetScreenHeight())
	{ Call("OnConstruct"); }

	virtual bool IsMouseOver() override;

	virtual void Debug()	override;
};


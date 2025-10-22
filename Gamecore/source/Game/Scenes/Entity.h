#pragma once

#include "InstanceBase.h"
#include "LuaInterface.h"
#include "Sprite.h"

#include <iostream>
#include <string>
#include <raylib-cpp.hpp>

//struct SpriteInfo
//{
//	std::string	NameId;
//	bool Visible = false;
//	bool Active = true;
//	bool Clickable = true;
//
//	int PositionX = 0;
//	int PositionY = 0;
//	float Alpha = 1.f;
//
//	Rectangle Size = { 0.0f, 0.0f, 1.0f, 1.0f };
//	std::vector<std::string> TexturesIDs;
//};


class Entity : public InstanceBase, public LuaInterface
{
protected:
	SpriteInfo Info;

	Tween tween { this->Info };

	Texture2D CurrentSprite;

	AlphaMask Mask;

	bool debug = false;
	bool Hovered = false;

	float highlightLapse = 0.f;

	friend class FSM;
	friend class Assets;

	// Subclasses override this to handle optional return values
	virtual void OnReturn() override;

public:

	inline const std::string& GetID() { return Info.NameId; }
	inline SpriteInfo& GetInfo() { return Info; }
	inline Texture2D& GetSprite() { return CurrentSprite; }
	inline Tween& GetTween() { return tween; }

	void SetSprite(const std::string& textureID);


	GETTERSETTER(bool, IsVisible, Info.Visible)
	GETTERSETTER(bool, IsActive, Info.Active)
	GETTERSETTER(bool, IsClickable, Info.Clickable)
	GETTERSETTER(bool, IsHovered, Hovered)
	GETTERSETTER(int, PositionX, Info.PositionX )
	GETTERSETTER(int, PositionY, Info.PositionY )
	GETTERSETTER(float, Alpha, Info.Alpha)
 
 
	Entity(const std::string& scriptPath) : LuaInterface(scriptPath) { Call("OnConstruct"); }

	virtual void OnInit()	override;
	virtual void OnDeinit()	override;

	virtual void OnUpdate(float deltaTime)	override;
	virtual void OnRender()	override;

	virtual void OnInteract();
	virtual void OnLook();
	virtual void OnCombine(const std::string& itemId);

	virtual bool IsMouseOver();
};


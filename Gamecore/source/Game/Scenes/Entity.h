#pragma once

#include "InstanceBase.h"
#include "LuaInterface.h"

#include <iostream>
#include <string>
#include <vector>

#include <raylib-cpp.hpp>


struct SpriteInfo
{
	std::string	NameId;
	bool Visible	= false;

	float PositionX	= 0.f;								// Current Horizontal position in Screen
	float PositionY	= 0.f;								// Current Vertical position in Screen
	float Alpha		= 1.f;								// Current Alpha Color Value

	Rectangle Size	= { 0.0f, 0.0f, 1.0f, 1.0f };
	std::vector<std::string> TexturesIDs;

	GETTERSETTER(bool, IsVisible, Visible)

	//float StartValue	= 0.f;
	//float EndValue		= 1.0f;
	//float CurrentTime	= 0.0f;
	//float TotalTime		= 3.0f;
	//bool Completed		= false;
};


class Entity : public InstanceBase, public LuaInterface
{
protected:
	SpriteInfo Info;

	Texture2D* CurrentSprite = nullptr;

	friend class FSM;

	// Subclasses override this to handle optional return values
	virtual void OnReturn() override;
 
public:
	Entity(const std::string& scriptPath) : LuaInterface(scriptPath) {}

	virtual void OnInit()	override;
	virtual void OnDeinit()	override;

	virtual void OnUpdate()	override;
	virtual void OnRender()	override;

	virtual void OnInteract();
	virtual void OnLook();
	virtual void OnCombine(const std::string& itemId);
};


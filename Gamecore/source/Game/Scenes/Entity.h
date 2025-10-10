#pragma once

#include "InstanceBase.h"
#include "LuaInterface.h"

#include <iostream>
#include <string>
#include <vector>
#include <bitset>

#include <raylib-cpp.hpp>

struct AlphaMask 
{
	int Width = 0;
	int Height = 0;
	std::vector<uint8_t> Opaque; // true = clickable pixel

	bool IsOpaque(int x, int y) const 
	{
		if (x < 0 || y < 0 || x >= Width || y >= Height)
			return false;
	
		return Opaque[y * Width + x];
	}

	void BuildAlphaMask(const Texture2D& texture)
	{
		Image img = LoadImageFromTexture(texture); 

		Width = img.width;
		Height = img.height;
		Opaque.resize(Width * Height);

		Color* pixels = LoadImageColors(img);

		for (int i = 0; i < img.width * img.height; ++i)
			Opaque[i] = (pixels[i].a > 128 ? 1 : 0);

		UnloadImageColors(pixels);
		UnloadImage(img); // clean CPU copy
	}
};

struct SpriteInfo
{
	std::string	NameId;
	bool Visible	= false;
	bool Active		= true;
	bool Clickable	= true;

	int PositionX	= 0;								// Current Horizontal position in Screen
	int PositionY	= 0;								// Current Vertical position in Screen
	float Alpha		= 1.f;								// Current Alpha Color Value

	Rectangle Size	= { 0.0f, 0.0f, 1.0f, 1.0f };
	std::vector<std::string> TexturesIDs;

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

	SpriteInfo& GetInfo() { return Info; }
	Texture2D& GetSprite() { return CurrentSprite; }

	void SetSprite(const std::string& textureID);


	GETTERSETTER(bool, IsVisible, Info.Visible)
	GETTERSETTER(bool, IsActive, Info.Active)
	GETTERSETTER(bool, IsClickable, Info.Clickable)
	GETTERSETTER(bool, IsHovered, Hovered)
	GETTERSETTER(int, PositionX, Info.PositionX )
	GETTERSETTER(int, PositionY, Info.PositionY )

 
	Entity(const std::string& scriptPath) : LuaInterface(scriptPath) { Call("OnConstruct"); }

	virtual void OnInit()	override;
	virtual void OnDeinit()	override;

	virtual void OnUpdate()	override;
	virtual void OnRender()	override;

	virtual void OnInteract();
	virtual void OnLook();
	virtual void OnCombine(const std::string& itemId);

	virtual bool IsMouseOver() const;
};


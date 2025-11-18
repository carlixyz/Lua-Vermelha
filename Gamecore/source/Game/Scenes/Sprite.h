#pragma once

#include <iostream>
#include <string>
#include <vector>
#include <bitset>
#include <functional>

#include <raylib-cpp.hpp>
#include <reasings.h>
#include "../../Graphics/Graphics.h"


struct AlphaMask
{
	int Width = 0;
	int Height = 0;
	std::vector<uint8_t> Opaque; // 1 = clickable pixel

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

		for (int i = 0; i < img.width* img.height; ++i)
			Opaque[i] = (pixels[i].a > 0 ? 1 : 0);

		UnloadImageColors(pixels);
		UnloadImage(img); // clean CPU copy
	}
};

struct SpriteInfo
{
	std::string	NameId;
	bool Visible = true;
	bool Active = true;
	bool Clickable = true;

	int PositionX= 0;								// Current Horizontal position in Screen
	int PositionY = 0;								// Current Vertical position in Screen
	float Alpha = 1.f;								// Current Alpha Color Value

	Rectangle Size = { 0.0f, 0.0f, 1.0f, 1.0f };
	std::vector<std::string> TexturesIDs;
};



class Tween
{
public:

	explicit Tween(SpriteInfo& info) : Sprite(info) { }

	inline Tween& ActionFade(float startValue, float endValue, float totalTime)
	{
		Tweens.emplace_back(Action {
			[this, startValue, endValue, totalTime, currentTime = 0.0f]
				(float dt) mutable {
				currentTime += dt;
				Sprite.Alpha = EaseCubicOut(currentTime, startValue, endValue - startValue, totalTime);
				return currentTime < totalTime; // return false when finished (auto-remove)
			}
		});

		return *this;
	}

	inline Tween& ActionMove(Vector2 startPos, Vector2 endPos, float totalTime)
	{
		Tweens.emplace_back(Action {
			[this, startPos, endPos, totalTime, currentTime = 0.0f]
				(float dt) mutable {
				currentTime += dt;
				Sprite.PositionX = (int)EaseExpoOut(currentTime, startPos.x, endPos.x - startPos.x, totalTime);
				Sprite.PositionY = (int)EaseExpoOut(currentTime, startPos.y, endPos.y - startPos.y, totalTime);
				return currentTime < totalTime; // return false when finished (auto-remove)
			}
			});

		return *this;
	}

	inline Tween& ActionShake(float amount, float totalTime)
	{
		Tweens.emplace_back(Action{
			[this, amount, totalTime,
			 currentTime = 0.0f,
			 startX = Sprite.PositionX,
			 startY = Sprite.PositionY](float dt) mutable
			{
				currentTime += dt;

				// normalized time (0..1)
				float t = currentTime / totalTime;
				if (t > 1.0f) t = 1.0f;

				// fade intensity using cubic ease-out (so shake calms down)
				float intensity = EaseCubicOut(currentTime, 1.0f, -1.0f, totalTime);
				float range = amount * intensity;

				// random offset each frame
				float offsetX = ((float)GetRandomValue(-1000, 1000) / 1000.0f) * range;
				float offsetY = ((float)GetRandomValue(-1000, 1000) / 1000.0f) * range;

				Sprite.PositionX = (int)(startX + offsetX);
				Sprite.PositionY = (int)(startY + offsetY);

				// finished?
				if (currentTime >= totalTime)
				{
					Sprite.PositionX = (int)startX;
					Sprite.PositionY = (int)startY;
					return false;
				}
				return true;
			}
			});

		return *this;
	}

	inline void Update(float dt)
	{
		// update tweens (auto-destroy when finished)
		for (auto it = Tweens.begin(); it != Tweens.end();) 
		{
			if (!it->Update(dt))
				it = Tweens.erase(it);
			else
				++it;
		}
	}

	bool IsFinished() const { return Tweens.empty(); }
	
protected:

	SpriteInfo& Sprite;
	
	struct Action
	{
		std::function<bool(float dt)> Update;			// returns false when finished
	};

	std::vector<Action> Tweens;
};
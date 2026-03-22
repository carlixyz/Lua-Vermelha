#pragma once


#include <raylib-cpp.hpp>

#include "../Assets.h"
#include "../../Graphics/Graphics.h"
#include "GameScene.h"

#include <vector>
#include <functional>


class AnimeScene : public GameScene
{
	using LoaderCustomFunction = std::function<void()>;

	unsigned int nextFrameDataOffset = 0;					// Current byte offset to next frame in image.data

	int animTotalFrames = 0;
	int currentAnimFrame = 0;								// Current animation frame to load and draw
	int frameDelay = 2;										// Frame delay to switch between animation frames
	int frameCounter = 0;									// General frames counter


	Texture2D IntroTexture;
	std::vector<Texture2D>* Frames	= nullptr;				// pointer so we can rebind it
	LoaderCustomFunction Loader		= nullptr;

	Texture2D& GetFrame(size_t index) { return (*Frames)[index]; }
	bool HasFrames() const { return Frames && !Frames->empty(); }

public:

	// Constructor with optional loader function and optional direct frames
	AnimeScene(std::vector<Texture2D>* frames = nullptr, LoaderCustomFunction loader = nullptr) :
		Frames(frames), Loader(loader) { }

	AnimeScene() {  }

	inline void OnInit()
	{
		GameScene::OnInit();

#ifndef EMSCRIPTEN
		if (Frames && Loader && Frames->empty()) Loader();
#endif

		if (HasFrames())
		{
			IntroTexture = GetFrame(0);
			animTotalFrames = (int)Frames->size();
		}
	}

	inline void OnDeinit()
	{
		GameScene::OnDeinit();

		Frames = nullptr;
		Loader = nullptr;
	}

	inline void OnUpdate(float dt)
	{
		// --------------------------------

		GameScene::OnUpdate(dt);

		frameCounter++;
		if (frameCounter >= frameDelay)
		{
			// Move to next frame, If final frame is reached we return to first frame
			currentAnimFrame++;
			if (currentAnimFrame >= animTotalFrames)
				currentAnimFrame = 0;

			if (HasFrames())
				IntroTexture = GetFrame(currentAnimFrame);

			frameCounter = 0;
		}
	}

	inline void OnRender()
	{
		if (HasFrames())
			DrawTexturePro(IntroTexture,
				Rectangle{ 0, 0, (float)IntroTexture.width, (float)IntroTexture.height },
				Rectangle{ 0, 0, (float)GetScreenWidth(), (float)GetScreenHeight() },
				Vector2Zero(),
				0.0f,
				WHITE);
		else
			DrawRectangle(0, 0, GetScreenWidth(), GetScreenHeight(), DARKBLUE);

		GameScene::OnRender();
	}
};
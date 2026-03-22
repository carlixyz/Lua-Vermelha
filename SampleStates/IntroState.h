#pragma once

#include "GameState.h"
#include <raylib-cpp.hpp>
#include "../../Graphics/FX/ThunderFlash.h"
#include <vector>

class IntroState :  public GameState
{

    Texture2D IntroTexture;					// = LoadTextureFromImage(imScarfyAnim);

    unsigned int nextFrameDataOffset	= 0;		// Current byte offset to next frame in image.data

	int animTotalFrames					= 0;
    int currentAnimFrame				= 0;		// Current animation frame to load and draw
    int frameDelay						= 2;		// Frame delay to switch between animation frames
    int frameCounter					= 0;		// General frames counter

	Image Noise;
	std::vector<Texture2D> LeNoise;
	int NoiseIndex						= 0;

	ThunderFlash Thunder;

public:

	void OnInit();
	void OnDeinit();

	void OnUpdate();
	void OnRender();

};
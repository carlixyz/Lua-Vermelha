#pragma once
#include "GameState.h"
#include <raylib-cpp.hpp>

#include "../../Graphics/PixelBuffer.h"
#include "../../Graphics/FX/ThunderFlash.h"


class RoadState : public GameState
{

    //// --- Load tile image and texture ---
    PixelBuffer Pixels { 320, 240};
    PixelBuffer TreePixels { 320, 240};

    // Pixel buffer and its texture
    Image bufferImg;
    Texture2D bufferTex;

    float t = 0.0f;                 // forward displacement
    float speed = 0.25f;            // forward speed (units/sec)
    float angle = 0.0f;             // rotation (radians)
    float Skyangle = 0.15f;         // rotation (radians)

    const float horizon = Pixels.Height * 0.45f;
    const float scale = 120.0f;
    const float lateralScale = 0.01f;

    float       horizonFactor = 0.45f;                       // horizon position
    int         horizonY = (int)(Pixels.Height * horizonFactor);

    float       groundScrollSpeed = 5.0f;                    // normal scroll speed
    float       skyScrollSpeed = 0.15f;                      // slower scroll
    float       tGround = 0.0f;
    float       tSky = 0.0f;

    // Load ground & sky textures once at init
    Image       groundImg;
    Texture2D   groundTex;
    Image       skyImg;
    Texture2D   skyTex;

    Texture2D   sideForest;
    int         forestX;            // center horizontally
    int         forestY;            // place at horizon

    ThunderFlash thunder;

    float frequency = 0.03f; // probability per frame (0.01 = ~1%)
    float fadeSpeed = 2.0f;  // alpha units per second
    int maxAlpha = 255;      // maximum brightness of flash

    float SkyThunderFlash = 0.0f;    // 0 = no flash, 1 = full white
    float SkyThunderTimer = 0.0f;    // time accumulator

public:

	void OnInit();
	void OnDeinit();

	void OnUpdate();
	void OnRender();

};


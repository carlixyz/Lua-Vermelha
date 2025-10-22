#pragma once

#include <string>

struct ApplicationProperties
{
	std::string ApplicationName = "Raycaster";

	unsigned Width				= 920; // = 720; // = 920 // 1280
	unsigned Height				= 516;  // = 480; // = 500 // = 720
	unsigned Bits				= 32;
	unsigned FPS				= 60;

	bool Fullscreen				= false;
	bool DebugMode				= false;
	bool SkipIntro				= false;
};


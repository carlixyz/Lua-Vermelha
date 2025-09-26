#pragma once

#include <string>

struct ApplicationProperties
{
	std::string ApplicationName = "Raycaster";

	unsigned Width				= 1280; // = 640;
	unsigned Height				= 720;  // = 480
	unsigned Bits				= 32;
	unsigned FPS				= 60;

	bool Fullscreen				= false;
	bool DebugMode				= false;
	bool SkipIntro				= false;
};


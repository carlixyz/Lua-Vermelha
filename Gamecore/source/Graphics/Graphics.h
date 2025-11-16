#ifndef _GRAPHICS_H
#define _GRAPHICS_H

#include "../Utility/Singleton.h"

#include <raylib-cpp.hpp>

#include "FX/CurtainWipe.h"
#include "FX/CurtainBlend.h"
#include "FX/Toaster.h"
#include "FX/SplashTitle.h"
#include "FX/ThunderFlash.h"
#include "FX/Noise.h"
#include "FX/SoftPopup.h"


struct ApplicationProperties;


class Graphics : public Singleton<Graphics>
{

	bool CloseApplication		= false;

	RWindow* Window				= nullptr;

	Rectangle WindowArea		{ 0, 0, 640, 480 };

	CurtainWipe Wiper;

	ThunderFlash Thunder;

	CurtainBlend Blender;

	Toaster Toasty;

	SplashTitle Splash;

	NoiseFX LeNoise;

	SoftPopup Popup;

	void SwitchFullScreen();

public:
	friend class Singleton<Graphics>;

	CurtainWipe& GetWiper() { return Wiper; }

	CurtainBlend& GetBlender() { return Blender; }

	ThunderFlash& GetThunder() { return Thunder; }

	NoiseFX& GetNoiser() { return LeNoise; }

	Toaster& GetToaster() { return Toasty; }

	void ToastMessage(const std::string& text, Vector2 pos, float duration = 3.0f, float size = 24.f, Color color = RAYWHITE)
	{ Toasty.AddMessage(text, pos, duration, size, color); }

	void SplashTitle(const std::string& text, float duration = 3.0f, float size = 24.f, Vector2 pos = { 0,0 }, Color color = RAYWHITE)
	{ Splash.Start(text, duration, size, pos, color); }

	void ShowPopup(const std::string& text, float duration = 3.0f) { Popup.ShowPopup(text, duration); }

	bool Init(ApplicationProperties* appProperties);

	bool Deinit();

	void Update(float deltaTime);

	void Render();


	bool GetCloseApplication();

	const Rectangle& GetWindowArea()	{ return WindowArea; }

	inline int GetHorizontalCenter()	{ return (int)(GetWindowArea().width * 0.5f); }
	inline int GetVerticalCenter()		{ return (int)(GetWindowArea().height * 0.5f); }
	inline Vector2 GetScreenCenter() 
	{
		return Vector2{ GetWindowArea().width * 0.5f,
						 GetWindowArea().height * 0.5f };
	}

protected:
	Graphics() { ; }					// Protected Constructor

};

#endif // !_GRAPHICS_H
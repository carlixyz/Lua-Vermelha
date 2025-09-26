#ifndef _GRAPHICS_H
#define _GRAPHICS_H

#include "../Utility/Singleton.h"

#include <raylib-cpp.hpp>


struct ApplicationProperties;


struct Star {
	float x, y, z;
};


class Graphics : public Singleton<Graphics>
{

	bool CloseApplication		= false;

	RWindow* Window				= nullptr;

	Rectangle WindowArea		{ 0, 0, 640, 480 };

	void SwitchFullScreen();

public:
	friend class Singleton<Graphics>;

	bool Init(ApplicationProperties* appProperties);

	bool Deinit();

	void Update();

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
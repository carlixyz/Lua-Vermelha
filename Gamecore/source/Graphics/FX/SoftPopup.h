#include <raylib-cpp.hpp>
#include <string>

struct SoftPopup 
{
	std::string message;
	float timer = 0.0f;

	void ShowPopup(const std::string& msg, float duration = 2.5f)
	{
		message = msg;
		timer = duration;
	}

	void Update(float dt)
	{
		if (timer > 0.0f)
		{
			timer -= dt;
			DrawRectangle(50, 50, 400, 60, Fade(BLACK, 0.5f));
			DrawText(message.c_str(), 70, 70, 20, ORANGE);
		}
	}
};
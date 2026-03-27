#include "Game.h"

#include "Assets.h"
#include "Director.h"
#include "QuadCapture.h"

#include "../Graphics/Graphics.h"
#include "../Audio/Audio.h"
#include "../Lua/LuaManager.h"

bool Game::Init()
{

	bool result = Graphics::Get().Init(&appProperties);

#ifndef EMSCRIPTEN
	HideCursor();
#endif

	SetExitKey(KEY_Q);

	if (!result) Graphics::Get().Deinit();	// CloseWindow();	// If something fails Kill Window

	result = result && Audio::Get().Init();

	result = result && Assets::Get().Init();

	result = result && Director::Get().Init();		

	result = result && LuaManager::Get().Init();				

	result = result && QuadCaptureTool::Get().Init();

	result = result && Scenes.Init();							//	Scenes.Init(Scenes.introState);


	return result;
}

bool Game::Deinit()
{
	bool result = Scenes.Deinit();								// cleanup the all states

	result = result && LuaManager::Get().Deinit();

	result = result && Assets::Get().Deinit();

	result = result && Director::Get().Deinit();

	result = result && Graphics::Get().Deinit();

	result = result && Audio::Get().Deinit();

	result = result && QuadCaptureTool::Get().Deinit();

	return result;
}




void Game::Update(float deltaTime)
{
	finish = (finish || Graphics::Get().GetCloseApplication());
	if (finish) return;


	if (IsKeyPressed(KEY_KP_DIVIDE))
		debug = !debug;

#ifdef EMSCRIPTEN

	// --- Lock/unlock logic ---
	if (!mouseCaptured && IsMouseButtonPressed(MOUSE_LEFT_BUTTON))
	{
        DisableCursor();
		mouseCaptured = true;
		HideCursor();
		EnableCursor();
	}

	// ESC typically unlocks on the browser; this keeps state consistent cross-platform
    if (IsKeyPressed(KEY_ESCAPE)) 
	{
		mouseCaptured = false;
        EnableCursor();
	}
#endif

	QuadCaptureTool::Get().OnUpdate(deltaTime);

	Graphics::Get().Update(deltaTime);

	LuaManager::Get().Update(deltaTime);

	Director::Get().Update(deltaTime);
	
	Scenes.Update(deltaTime);  										/// <--------------------

	Audio::Get().Update();


}

void Game::Render()
{
	BeginDrawing();

	ClearBackground(BLACK);

	Scenes.Render();												/// <--------------------

	QuadCaptureTool::Get().OnRender();

	LuaManager::Get().Render();

	Graphics::Get().Render();

	RenderCursor();	// Can be Done inside Scenes.Render() to avoid Inventory overlap

	EndDrawing();
}


void Game::RenderCursor()
{
	Vector2 m = GetMousePosition();

	bool anyHovered = false;
	// You can store hovered pointer in the scene instead of scanning
	for (Entity* e : Scenes.GetCurrent()->Entities)
		if (e->GetIsHovered())
		{
			anyHovered = true;

			/// --- Hover feedback ---
			if (e->GetIsClickable())
				DrawTextEx(GetFont("Noto"),e->GetInfo().NameView.c_str(), { m.x + 12, m.y + 24 }, 16, 1.0f, WHITE);

			break;
		}

	DrawTexture(GetTexture(anyHovered ? "MB" : "MA"), (int)m.x, (int)m.y, WHITE);
}

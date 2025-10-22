#include "Game.h"

#include "Assets.h"
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

	result = result && LuaManager::Get().Init();				

	result = result && Scenes.Init();							//	Scenes.Init(Scenes.introState);

	return result;
}

bool Game::Deinit()
{
	bool result = Scenes.Deinit();								// cleanup the all states

	result = result && LuaManager::Get().Deinit();

	result = result && Assets::Get().Deinit();

	result = result && Graphics::Get().Deinit();

	result = result && Audio::Get().Deinit();

	return result;
}


void Game::Update(float deltaTime)
{
	finish = (finish || Graphics::Get().GetCloseApplication());
	if (finish) return;

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

	Graphics::Get().Update(deltaTime);

	Scenes.Update(deltaTime);  										/// <--------------------

	Audio::Get().Update();

	LuaManager::Get().Update();

}

void Game::Render()
{
	BeginDrawing();

	ClearBackground(BLACK);

	Scenes.Render();										/// <--------------------
	
	//DrawTexture(GetTexture("MA"), GetMouseX(), GetMouseY(), WHITE);

	LuaManager::Get().Render();

	Graphics::Get().Render();

	EndDrawing();
}

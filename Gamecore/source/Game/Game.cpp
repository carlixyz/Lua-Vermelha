#include "Game.h"

#include "Assets.h"
#include "../Graphics/Graphics.h"
#include "../Audio/Audio.h"
#include "../Lua/LuaManager.h"

//#include "../Utility/Utils.h"
//#include "ConversationManager.h"
//#include "VisualDialogManager.h"


bool Game::Init()
{


	bool result = Graphics::Get().Init(&appProperties);

	SetExitKey(KEY_Q);

	if (!result) Graphics::Get().Deinit();	// CloseWindow();	// If something fails Kill Window

	result = result && Audio::Get().Init();

	//result = result && Assets::Get().Init();

	result = result && States.Init();							//	States.Init(States.introState);

	result = result && LuaManager::Get().Init();				

	return result;
}

bool Game::Deinit()
{
	bool result = States.Deinit();								// cleanup the all states

	//ConversationManager::Get().Deinit();

	//VisualDialogManager::Get().Deinit();

	result = result && LuaManager::Get().Deinit();

	//result = result && Assets::Get().Deinit();

	result = result && Graphics::Get().Deinit();

	result = result && Audio::Get().Deinit();

	return result;
}

void Game::Update()
{
	finish = (finish || Graphics::Get().GetCloseApplication());
	if (finish) return;

	Graphics::Get().Update();

	States.CurrentState().OnUpdate();						/// statesStack.top()->OnUpdate(timeStep);

	//VisualDialogManager::Get().Update();

	//ConversationManager::Get().Update();

	Audio::Get().Update();

	LuaManager::Get().Update();
}

void Game::Render()
{
	BeginDrawing();

	ClearBackground(BLACK);

	Graphics::Get().Render();

	States.CurrentState().OnRender();						/// statesStack.top()->OnRender();

	LuaManager::Get().Render();

	//MapInstance.Render();

	//VisualDialogManager::Get().Render();

	//ConversationManager::Get().Render();

	EndDrawing();
}

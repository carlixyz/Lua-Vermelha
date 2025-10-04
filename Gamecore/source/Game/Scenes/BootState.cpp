#include "BootState.h"

#include "../Game.h"
#include "../../Graphics/Graphics.h"
#include "./reasings.h"

void BootState::OnInit()
{
	//* Add any of your logos
	Logos.push_back(new raylib::TextureUnmanaged("data/raylib_logo.png"));
	Logos.push_back(new raylib::TextureUnmanaged("data/InderFort.png"));
	Logos.push_back(new raylib::TextureUnmanaged("data/Sun.png"));
}

void BootState::OnDeinit()
{
	for (auto& logo : Logos)
	{
		logo->Unload();
		delete logo;
	}

	Logos.clear();
}

void BootState::OnUpdate()
{
	
	CurrentTime += GetFrameTime();
	Alpha = EaseSineInOut(CurrentTime, 0.0f, 1.0f, TotalTime);
	

	if (IsKeyDown(KEY_ENTER))
	{
		//Game::Get().Scenes.ChangeState(Game::Get().Scenes.titleState);
		return;
	}

	if (IsKeyDown(KEY_SPACE))
	{
		CurrentTime += GetFrameTime() * 4;
	}

	if (CurrentTime > (TotalTime * 2))
	{
		CurrentTime = 0;
		CurrentLogo++;

		if (CurrentLogo >= Logos.size())
		{
			//Game::Get().Scenes.Deinitialize("Boot");
			//return;
			//CurrentLogo = (int)Logos.size() - 1;
			Game::Get().Scenes.ChangeCurrent(SceneID::Test);
			//Game::Get().Scenes.ChangeState(Game::Get().Scenes.introState);
		}
	}
}

void BootState::OnRender()
{
	if (!Logos.empty() && Logos[CurrentLogo] && Logos[CurrentLogo]->IsReady())
	{
		const Vector2 Position = { 
			Graphics::Get().GetHorizontalCenter() - (float)Logos[CurrentLogo]->GetWidth() * 0.5f,
			Graphics::Get().GetVerticalCenter() - (float)Logos[CurrentLogo]->GetHeight() * 0.5f	};

		Logos[CurrentLogo]->Draw( Position, 0.0f, 1.0f, Fade(WHITE, Alpha));
	}
	
}


//void BootState::OnExit()
//{
//}

//void BootState::OnEnter()
//{
//}

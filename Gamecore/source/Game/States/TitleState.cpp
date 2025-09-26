#include "TitleState.h"
#include "../Game.h"
#include "../../Graphics/Graphics.h"
//#include "../Assets.h"
#include "../../Audio/Audio.h"
#include <iostream>
#include <string>
#include "./reasings.h"

#define PADDING 100
#define SCREEN_CENTER_H (int)(Graphics::Get().GetWindowArea().width * 0.5f)
#define SCREEN_CENTER_V (int)(Graphics::Get().GetWindowArea().height * 0.5f)

#define DEMO_MODE 1


void TitleState::OnInit()
{
	TitleLogo.Load("data/PsyTronTitle.png");

	FontSize = 16;

	MenuOptions.push_back("Introduction");
	MenuOptions.push_back(" Start Game ");
	MenuOptions.push_back("   Credits  ");


	credits.push_back("Idea & Programming");
	credits.push_back("Charlie");
	credits.push_back("Raylib framework");
	credits.push_back("Ramon Santamaria");
	credits.push_back("FX Sprites");
	credits.push_back("Renzo Maccarinni");
	credits.push_back("VN Intro CG");
	credits.push_back("Stable Diffusion");
	credits.push_back("Shmup logic");
	credits.push_back("ChatGPT");
	credits.push_back("Firestorm Track by");
	credits.push_back("Doranarasi.com");
	credits.push_back("General VN Soundtrack by");
	credits.push_back("Eric Matyas");
	credits.push_back(" ");
	credits.push_back("Visit Soundimage.org");

	//------------------------------------------------------------------------------
	//Audio::Get().PreloadSound("data/Sound/explode.wav");
	//Audio::Get().PreloadSound("data/Sound/fx/hit-fx.wav");
	//Audio::Get().PreloadSound("data/Sound/fx/shot-obliterator.wav");
	//Audio::Get().PreloadSound("data/Sound/fx/shot-single-gun.wav");
	//Audio::Get().PreloadSound("data/Sound/fx/shot-reverb.wav");
}

void TitleState::OnDeinit()
{
	if (TitleLogo.IsReady())
		TitleLogo.Unload();
}

void TitleState::OnUpdate()
{
#ifndef DEMO_MODE
	if (!ShowCredits)
	{
		if (IsKeyPressed(KEY_UP) || IsKeyPressed(KEY_W))
		{
			Audio::Get().PlaySound("data/Sound/fx/game-ui.ogg");
			CurrentIndex--;
		}
		if (IsKeyPressed(KEY_DOWN) || IsKeyPressed(KEY_S))
		{
			Audio::Get().PlaySound("data/Sound/fx/game-ui.ogg");
			CurrentIndex++;
		}
		CurrentIndex = (int)Clamp((float)CurrentIndex, 0.f, MenuOptions.size() - 1.f);
	}
#endif

	if (CurrentTime < TotalTime)
	{
		CurrentTime += GetFrameTime();
		Alpha = EaseCircInOut(CurrentTime, 0.0f, 1.0f, TotalTime);
		return;
	}

	CurrentTime += GetFrameTime();
	if (CurrentTime > StoryTime)
	{
		Game::Get().States.PushState(Game::Get().States.dialogState);
		Audio::Get().PlaySound("data/Sound/fx/game-start.ogg");
	}
	
#ifndef DEMO_MODE
	if (IsKeyPressed(KEY_SPACE) || IsKeyPressed(KEY_ENTER))
	{
		switch (CurrentIndex)
		{
			case 0:

				Game::Get().States.PushState(Game::Get().States.dialogState);
				break;
			case 1:	
				
				//Game::Get().States.PushState(Game::Get().States.ingameState);
				break;
			case 2:
				ShowCredits = !ShowCredits;	// Toogle show Credits mode
				break;
		}

		Audio::Get().PlaySound("data/Sound/fx/game-start.ogg");
	}
#endif
}

void TitleState::DrawCredits()
{
	int i = 0, j = 0;

	const int LeftColumn = Graphics::Get().GetHorizontalCenter() - 200;
	const int RightColumn = Graphics::Get().GetHorizontalCenter() + 50;

	for (auto& credit : credits)
	{
		DrawText(credit.c_str(),
			i % 2 == 0 ? LeftColumn : RightColumn,
			Graphics::Get().GetVerticalCenter() + FontSize * j,
			FontSize,
			SKYBLUE);
		i++;
		j += (i % 2 == 0) ? 1 : 0;
	}
}


void TitleState::OnRender()
{
	if (ShowCredits)
	{
		DrawCredits();
		return;
	}

	if (TitleLogo.IsReady())
		DrawTexturePro(TitleLogo, 
					   { 0, 0, 
					   (float)TitleLogo.width, 
					   (float)TitleLogo.height},
					   { Graphics::Get().GetHorizontalCenter() - TitleLogo.width * 0.5f,
					     Graphics::Get().GetVerticalCenter() - TitleLogo.height * 0.5f,
						(float)TitleLogo.width ,
						(float)TitleLogo.height },
					   Vector2Zero(),
					   0.0f,
					   Fade(WHITE, Alpha));

	if ( Alpha >= 0.9f )
	{
#ifdef DEMO_MODE
		DrawCredits();

		DrawText("DEMOSTRATION",
			Graphics::Get().GetHorizontalCenter() - ((int)6 * FontSize),
			PADDING + Graphics::Get().GetVerticalCenter() + 42,
			(int)(FontSize * 1.5f),
			Fade(WHITE, Alpha));

		DrawText("Download game in the link below to enjoy the full experience",
			Graphics::Get().GetHorizontalCenter() - ((int)14 * FontSize),
			PADDING + Graphics::Get().GetVerticalCenter() + 64,
			FontSize,
			Fade(SKYBLUE, Alpha));
#else
		int i = 0;
		for (auto& option : MenuOptions)
		{
			DrawText(option.c_str(),
						Graphics::Get().GetHorizontalCenter() - ((int)(option.size() / 2 * FontSize / 2)),
						PADDING + Graphics::Get().GetVerticalCenter() + FontSize * i,
						FontSize,
						CurrentIndex == i++ ? Fade(WHITE, Alpha) : Fade(SKYBLUE, Alpha));
		}
#endif

	}
}

void TitleState::OnPause()
{
}

void TitleState::OnResume()
{
	CurrentTime = 0.0f;
	Alpha = 0.0f;
}

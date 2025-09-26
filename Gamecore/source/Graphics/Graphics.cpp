#include "Graphics.h"
#include "ApplicationProperties.h"

//#include <assert.h>

static float Noise2D(float x, float y) {
	// Simple pseudo-random smooth noise using sin
	return 0.5f + 0.5f * sinf(x * 12.9898f + y * 78.233f) *
		sinf(x * 4.123f + y * 37.719f);
}


bool Graphics::Init(ApplicationProperties* appProperties)
{
	bool Result = true;

	//SetConfigFlags(FLAG_WINDOW_RESIZABLE);

	Window = new raylib::Window(	appProperties->Width,
									appProperties->Height, 
									appProperties->ApplicationName);



	SetTargetFPS(appProperties->FPS);

	if (appProperties->Fullscreen) SwitchFullScreen();

	WindowArea = {	GetWindowPosition().x,
					GetWindowPosition().y,
					(float)appProperties->Width,
					(float)appProperties->Height };

	return Result;
}



bool Graphics::Deinit()
{
	if (Window)
		CloseWindow();

	delete Window;

	return true;
}

void Graphics::Update()
{
	// check for alt + enter
	if (IsKeyPressed(KEY_ENTER) && (IsKeyDown(KEY_LEFT_ALT) || IsKeyDown(KEY_RIGHT_ALT)))
	{
		Graphics::Get().SwitchFullScreen();
	}
}

void Graphics::SwitchFullScreen()
{
	// Don't mess with specs just toggle the state
	Window->ToggleFullscreen();

	if ( !Window->IsFullscreen())	//if (IsWindowFullscreen())
	{
		// if we are full screen, then go back to the windowed size
		Window->SetSize((int)WindowArea.width, (int)WindowArea.height);
		Window->SetPosition((int)WindowArea.x, (int)WindowArea.y);
	}
	else
	{
		// see what display we are on right now
		int display = GetCurrentMonitor();
		// if we are not full screen, set the window size to match the monitor we are on
		Window->SetSize(GetMonitorWidth(display), GetMonitorHeight(display));
	}
}


void Graphics::Render()
{

	// --- Draw ---
	//ClearBackground(BLACK);

	/// Draw the pixel buffer scaled to window size
	//DrawTexturePro(
	//	BufferTexture,
	//	Rectangle{ 0, 0, (float)BufferArea.width, (float)BufferArea.height },
	//	Rectangle{ 0, 0, (float)GetWindowArea().width, (float)GetWindowArea().height},
	//	Vector2{ 0, 0 },
	//	0.0f,
	//	WHITE
	//);
}

bool Graphics::GetCloseApplication()
{
	CloseApplication = Window->ShouldClose();
	return CloseApplication;
}

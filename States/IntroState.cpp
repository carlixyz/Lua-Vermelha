#include "IntroState.h"

#include "../../Graphics/Graphics.h"
#include "../Assets.h"


void IntroState::OnInit()
{
    if (!Assets::Get().NightDriveIntro().empty())
    {
        IntroTexture = Assets::Get().NightDriveIntro()[0];
        animTotalFrames = (int)Assets::Get().NightDriveIntro().size();
    }

    //IntroTexture = Assets::Get().MansionIntro()[0];
    //animTotalFrames = Assets::Get().MansionIntro().size();

    for (int i = 0; i < 10; i++)
    {
        Noise = GenImageWhiteNoise(GetScreenWidth(), GetScreenHeight(), 0.3f);

        LeNoise.push_back(LoadTextureFromImage(Noise));
        UnloadImage(Noise);
    }
}

void IntroState::OnDeinit()
{
}

void IntroState::OnUpdate()
{
    // --------------------------------

    frameCounter++;
    if (frameCounter >= frameDelay)
    {
        // Move to next frame, If final frame is reached we return to first frame
        currentAnimFrame++;
        if (currentAnimFrame >= animTotalFrames) currentAnimFrame = 0;

        if (!Assets::Get().NightDriveIntro().empty())
            IntroTexture = Assets::Get().NightDriveIntro()[currentAnimFrame];
        //IntroTexture = Assets::Get().MansionIntro()[currentAnimFrame];

        frameCounter = 0;
    }

    NoiseIndex++;
    NoiseIndex = NoiseIndex % 10;

    Thunder.Update(GetFrameTime());

    if (IsKeyPressed(KEY_SPACE)) {
            Thunder.Trigger(3, 120, 200); // 3 strong flashes, intensity 120–200

    }

}

void IntroState::OnRender()
{
    if (!Assets::Get().NightDriveIntro().empty())
        DrawTexturePro(IntroTexture,
            Rectangle { 0, 0, (float)IntroTexture.width, (float)IntroTexture.height },
            Rectangle { 0, 0, (float)GetScreenWidth(), (float)GetScreenHeight() },
            Vector2Zero(),
            0.0f, 
            WHITE);


    //DrawTexture(LeNoise[NoiseIndex], 0, 0, Fade(WHITE, 0.1f)); // adjust alpha
    DrawTexture(LeNoise[NoiseIndex], 0, 0, Fade(WHITE, 0.07f)); // adjust alpha

    Thunder.Draw();

}


//void IntroState::OnPause()
//{
//}

//void IntroState::OnResume()
//{
//}

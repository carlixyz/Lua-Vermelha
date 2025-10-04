#include "RoadState.h"
#include "../../Graphics/Graphics.h"

#include <cmath>




void RoadState::OnInit()
{

    bufferImg = GenImageColor(Pixels.Width, Pixels.Height, SKYBLUE);
    bufferTex = LoadTextureFromImage(bufferImg);

    Pixels.LoadFromImage(bufferImg);


    // Load ground & sky textures once at init
    groundImg = LoadImage("data/dark-gravel.png"); // "data/black-asphalt.png");
    groundTex = LoadTextureFromImage(groundImg);
    skyImg = LoadImage("data/puffy_sky-night_01.png"); 
    skyTex = LoadTextureFromImage(skyImg);

    sideForest = LoadTexture("data/sideForest-horizon.png");
    forestX = (Pixels.Width - sideForest.width) / 2; // center horizontally
    forestY = horizonY;          // place at horizon

    // Call this once at program start
    srand((unsigned int)time(0));
}

void RoadState::OnDeinit()
{
    UnloadImage(groundImg);
    UnloadImage(skyImg);
    
    UnloadTexture(bufferTex);
    UnloadTexture(groundTex);
    UnloadTexture(skyTex);
}


void RoadState::OnUpdate()
{
    //if (IsKeyDown(KEY_ENTER))
    //{
    //    Game::Get().States.ChangeState(Game::Get().States.roadState);
    //    return;
    //}

    // --------------------------------


    float dt = GetFrameTime();

    // Controls
    if (IsKeyDown(KEY_RIGHT)) angle += 0.01f * dt;
    if (IsKeyDown(KEY_LEFT))  angle -= 0.01f * dt;
    if (angle < -0.01f) angle = 0.0f;
    if (angle > 0.02f) angle = 0.01f;

    if (IsKeyDown(KEY_UP))    speed += 2.0f * dt;
    if (IsKeyDown(KEY_DOWN))  speed -= 2.0f * dt;
    if (speed < 0.0f) speed = 0.0f;
    

    t += speed * dt;

    float cosA = cosf(angle);
    float sinA = sinf(angle);

    float cosSky = cosf(Skyangle);
    float sinSky = sinf(Skyangle);

    //groundScrollSpeed = speed;
    tGround += groundScrollSpeed * dt;
    tSky += skyScrollSpeed * dt;

    // Update pixel buffer
    for (int y = 0; y < Pixels.Height; ++y) {

        if (y >= horizonY) {
            // --- GROUND AREA ---
            float dy = (float)(y - horizonY);
            float perspective = scale / (dy + 1.0f);
            float worldY = tGround + perspective;

            float blend = 1.0f - (dy / (float)(Pixels.Height - horizonY));
            if (blend < 0.0f) blend = 0.0f;

            Color fogColor = BLACK;

            for (int x = 0; x < Pixels.Width; ++x) {
                float screenX = ((float)x - Pixels.Width * 0.5f) * perspective * lateralScale;

                //float worldX = screenX * 1 - worldY * 0;
                //float worldZ = screenX * 0 + worldY * 1;
                float worldX = screenX * cosA - worldY * sinA;
                float worldZ = screenX * sinA + worldY * cosA;

                int texX = ((int)(worldX * 32) & (groundImg.width - 1));
                int texY = ((int)(worldZ * 32) & (groundImg.height - 1));

                Color texel = GetImageColor(groundImg, texX, texY);
                Pixels[y * Pixels.Width + x] = {
                    (unsigned char)((1.0f - blend) * texel.r + blend * fogColor.r),
                    (unsigned char)((1.0f - blend) * texel.g + blend * fogColor.g),
                    (unsigned char)((1.0f - blend) * texel.b + blend * fogColor.b),
                    255
                };
            }

        }
        else {
            // --- SKY AREA ---
            float dy = (float)(horizonY - y);           // distance above horizon
            float perspective = scale / (dy + 1.0f);    // zoom factor upward
            float worldY = tSky + perspective;

            float blend = 1.0f - (dy / (float)horizonY);
            if (blend < 0.0f) blend = 0.0f;

            Color fogColor = { (unsigned char)(10 + 10 * blend),
                               (unsigned char)(20 + 20 * blend),
                               (unsigned char)(50 + 50 * blend),
                               255 };

            for (int x = 0; x < Pixels.Width; ++x) {
                float screenX = ((float)x - Pixels.Width * 0.5f) * perspective * lateralScale;
                float worldX = screenX * cosSky + worldY * sinSky;  // flipped sign to scroll upward
                float worldZ = screenX * sinSky - worldY * cosSky;

                int texX = ((int)(worldX * 32) & (skyImg.width - 1));
                int texY = ((int)(worldZ * 32) & (skyImg.height - 1));

                Color texel = GetImageColor(skyImg, texX, texY);
                //Pixels[y * Pixels.Width + x] = {
                Color& currentPixel = Pixels[y * Pixels.Width + x];
                currentPixel = {
                    (unsigned char)((1.0f - blend) * texel.r + blend * fogColor.r),
                    (unsigned char)((1.0f - blend) * texel.g + blend * fogColor.g),
                    (unsigned char)((1.0f - blend) * texel.b + blend * fogColor.b),
                    255
                };
                

                // Apply thunder flash (blend toward white)
                if (SkyThunderFlash > 0.0f) {
                    currentPixel.r = (unsigned char)(currentPixel.r + (255 - currentPixel.r) * SkyThunderFlash);
                    currentPixel.g = (unsigned char)(currentPixel.g + (255 - currentPixel.g) * SkyThunderFlash);
                    currentPixel.b = (unsigned char)(currentPixel.b + (255 - currentPixel.b) * SkyThunderFlash);
                }

                Pixels[y * Pixels.Width + x] = currentPixel;

            }
        }
    }

    // Example thunder every ~5 seconds with quick fade-out
    SkyThunderTimer += GetFrameTime();

    //if (SkyThunderTimer > 5.0f) // trigger flash 
    if (SkyThunderTimer > GetRandomValue(3, 8))  // between 3–8 seconds
    {
        SkyThunderFlash = 1.0f;
        SkyThunderTimer = 0.0f;
    }

    // Smoothly fade the flash
    SkyThunderFlash -= GetFrameTime() * 3.0f; // adjust 3.0f for fade speed
    if (SkyThunderFlash < 0.0f) SkyThunderFlash = 0.0f;


    //Pixels.Copy(forestImg,  forestX, forestY);
    //Pixels.Copy(TreePixels, forestX, forestY - (TreePixels.Height * 0.5f));

    //UpdateTextureRec(bufferTex, Rectangle{ 0, 0, (float)Pixels.Width, (float)Pixels.Height }, Pixels.Buffer.data());

    thunder.Update(dt);
}


void RoadState::OnRender()
{
    //ClearBackground(BLACK);

    Pixels.Draw(2);

    //DrawTexturePro( bufferTex, Rectangle{ 0, 0, (float)Pixels.Width, (float)Pixels.Height },
    //    Rectangle{ 0, 0, (float)Graphics::Get().GetWindowArea().width, (float)Graphics::Get().GetWindowArea().height },
    //    Vector2{ 0, 0 }, 0.0f, WHITE);

    DrawTexture(sideForest, forestX, forestY, WHITE);

    DrawTextureRec(sideForest, Rectangle { 0.0f, 0.0f, (float)-sideForest.width, (float)sideForest.height }, 
        Vector2(Graphics::Get().GetWindowArea().width - sideForest.width, (float)forestY), WHITE);
    
    // Draw flash overlay
    thunder.Draw();

    //Pixels.Draw(0, 0, 2);
     

    DrawText("Mode7: arrows rotate/accelerate. Tile sampling is CPU-side.", 10, 10, 16, SKYBLUE);
    DrawText(TextFormat("speed: %.1f  angle: %.2f", speed, angle), 10, 30, 16, SKYBLUE);

}

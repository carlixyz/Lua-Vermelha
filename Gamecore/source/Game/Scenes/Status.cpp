#include "Status.h"

#include "../Register.h"

#include <cmath>

#define CONSTELATION 1


void Status::OnInit()
{
    Stars.clear();
    Links.clear();
    Time = 0.0f;

    GameScene::OnInit();
}


void Status::OnDeinit()
{
    Stars.clear();
    Links.clear();

    GameScene::OnDeinit();
}


void Status::OnUpdate(float deltaTime)
{
    Time += deltaTime;

    GameScene::OnUpdate(deltaTime);
}


void Status::OnRender()
{
    GameScene::OnRender();

    for (const StatusLink& link : Links)
        DrawLink(link);

    for (const StatusStar& star : Stars)
        DrawStar(star);
}

//void Status::OnRender()
//{
//    GameScene::OnRender();
//
//    DrawText(
//        TextFormat("Stars: %i  Links: %i", (int)Stars.size(), (int)Links.size()),
//        20, 180, 20, RED
//    );
//
//    DrawCircle(460, 256, 10, RED);
//
//    for (const StatusLink& link : Links)
//        DrawLink(link);
//
//    for (const StatusStar& star : Stars)
//        DrawStar(star);
//}


void Status::AddStar(const std::string& id, float x, float y)
{
    Stars.push_back({ id, { x, y } });
}


void Status::AddLink(const std::string& a, const std::string& b)
{
    int A = FindStar(a);
    int B = FindStar(b);

    if (A < 0 || B < 0)
        return;

    Links.push_back({ A, B });
}


int Status::FindStar(const std::string& id) const
{
    for (int i = 0; i < Stars.size(); i++)
        if (Stars[i].ID == id)
            return i;

    return -1;
}


bool Status::IsStarted(const StatusStar& star) const
{

    if (DebugShowAll)
        return true;

    if (star.ID == "You")
        return true;

    return Register::Get().IsThreadStarted(star.ID);
}


bool Status::IsCompleted(const StatusStar& star) const
{
    if (DebugShowAll)
        return true;

    if (star.ID == "You")
        return true;

    return Register::Get().IsThreadCompleted(star.ID);
}


Vector2 Status::GetPosition(const StatusStar& star) const
{
    return {
        Origin.x + star.Position.x * Size.x,
        Origin.y + star.Position.y * Size.y
    };
}


void Status::DrawLink(const StatusLink& link) const
{
    const StatusStar& A = Stars[link.A];
    const StatusStar& B = Stars[link.B];

    if (!IsCompleted(A) || !IsCompleted(B))
        return;

    Vector2 a = GetPosition(A);
    Vector2 b = GetPosition(B);

    DrawLineEx(a, b, 7.0f, Fade(SKYBLUE, 0.08f));
    DrawLineEx(a, b, 3.0f, Fade(SKYBLUE, 0.25f));
    DrawLineEx(a, b, 1.5f, Fade(WHITE, 0.85f));
}


void Status::DrawStar(const StatusStar& star) const
{
    if (!IsStarted(star))
        return;

    Vector2 position = GetPosition(star);

    bool completed = IsCompleted(star);

    if (!completed)
    {
        DrawCircleV(position, 2.0f, Fade(WHITE, 0.35f));
        return;
    }

    float pulse = 1.0f + sinf(Time * 2.0f) * 0.12f;

    DrawCircleV(position, 14.0f * pulse, Fade(SKYBLUE, 0.05f));
    DrawCircleV(position, 9.0f * pulse, Fade(SKYBLUE, 0.10f));
    DrawCircleV(position, 5.0f * pulse, Fade(WHITE, 0.25f));
    DrawCircleV(position, 2.5f, WHITE);
}
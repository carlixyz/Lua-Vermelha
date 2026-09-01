#pragma once

#include "GameScene.h"

#include <raylib.h>

#include <string>
#include <vector>


struct StatusStar
{
    std::string ID;
    Vector2 Position;
};

struct StatusLink
{
    int A = 0;
    int B = 0;
};


class Status : public GameScene
{
    std::vector<StatusStar> Stars;
    std::vector<StatusLink> Links;

    Vector2 Origin = { 220.0f, 45.0f };
    Vector2 Size = { 480.0f, 420.0f };

    float Time = 0.0f;

public:

    virtual void OnInit() override;
    virtual void OnDeinit() override;

    virtual void OnUpdate(float deltaTime) override;
    virtual void OnRender() override;

    void AddStar(const std::string& id, float x, float y);
    void AddLink(const std::string& a, const std::string& b);

private:

    bool DebugShowAll = true;

    int FindStar(const std::string& id) const;

    bool IsStarted(const StatusStar& star) const;
    bool IsCompleted(const StatusStar& star) const;

    Vector2 GetPosition(const StatusStar& star) const;

    void DrawStar(const StatusStar& star) const;
    void DrawLink(const StatusLink& link) const;
};
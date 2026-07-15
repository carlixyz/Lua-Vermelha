#pragma once

#include "GameScene.h"

#include <string>
#include <vector>

struct CreditLine
{
    enum class Type
    {
        Single,
        Pair,
        Empty,
        Command
    };

    Type type;
    std::string left;
    std::string right;
    int emptyLines = 1;
    bool executed = false;
};

class Credits : public GameScene
{
    float scrollY = 0.0f;
    float scrollSpeed = 50.0f;
    float lineHeight = 32.0f;
    float columnGap = 80.0f;

    bool rolling = false;

    std::vector<CreditLine> lines;

public:

    virtual void OnInit() override;
    virtual void OnDeinit() override;

    virtual void OnUpdate(float deltaTime) override;
    virtual void OnRender() override;

    void PushSingle(const std::string& text);
    void PushPair(const std::string& left, const std::string& right);
    void PushEmpty(int count = 1);

    void RollCredits(bool enabled = true);
};
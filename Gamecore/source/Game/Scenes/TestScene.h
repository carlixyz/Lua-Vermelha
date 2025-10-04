#pragma once

#include "GameScene.h"
#include <raylib-cpp.hpp>

class TestScene : public GameScene
{


public:

	virtual void OnInit() override;
	virtual void OnDeinit() override;

	virtual void OnUpdate() override;
	virtual void OnRender() override;

};
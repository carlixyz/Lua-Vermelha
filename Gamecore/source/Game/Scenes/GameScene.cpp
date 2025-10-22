#include "GameScene.h"
#include "Entity.h"
#include "../Game.h"
#include "../Assets.h"


void GameScene::OnInit()
{
	for (Entity* entity : Entities)
	{
		entity->OnInit();
	}
}

void GameScene::OnDeinit()
{
	for (Entity* entity : Entities)
	{
		entity->OnDeinit();
		delete entity;
	}

	Entities.clear();
}

void GameScene::OnEnter()
{
	for (Entity* entity : Entities)
	{
		entity->OnEnter();
	}
}

void GameScene::OnExit()
{
	for (Entity* entity : Entities)
	{
		entity->OnExit();
	}
}

void GameScene::OnUpdate(float deltaTime)
{
	for (Entity* entity : Entities)
	{
		if (entity->GetIsActive())
			entity->OnUpdate(deltaTime);
	}
}

void GameScene::OnRender()
{
	for (Entity* entity : Entities)
	{
		if (entity->GetIsVisible())
			entity->OnRender();
	}
}
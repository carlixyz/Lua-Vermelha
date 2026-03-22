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

void  GameScene::RequestMoveFront(const std::string& id, int offset) 
{
	pendingSorts.push_back({ id, (int)Entities.size() - 1 - offset }); /// If We want to be over everything We move it last
}

void  GameScene::RequestMoveBack(const std::string& id, int offset) 
{
	pendingSorts.push_back({ id, offset });								/// Otherwise move to the start and set it behind
}

void GameScene::SortEntity(const std::string& id, int newIndex)
{
	int oldIndex = FindEntityIndex(id);
	if (oldIndex < 0) return; // not found

	// clamp target index
	newIndex = (int)Clamp((float)newIndex, 0.f, (float)Entities.size() - 1);

	// no change?
	if (oldIndex == newIndex) return;

	Entity* e = Entities[oldIndex];
	Entities.erase(Entities.begin() + oldIndex);
	Entities.insert(Entities.begin() + newIndex, e);
}

void GameScene::ResolveHover()
{
	hoveredEntity = nullptr;

	// topmost wins: iterate reverse render order
	for (int i = (int)Entities.size() - 1; i >= 0; --i)
	{
		Entity* e = Entities[i];

		if (!e->GetIsVisible())   continue;
		if (!e->GetIsActive())    continue;
		if (!e->GetIsClickable()) continue;

		if (e->IsMouseOver())
		{
			hoveredEntity = e;
			break;
		}
	}

	// Only touch flags when they actually change (optional micro-opt)
	for (Entity* e : Entities)
		e->SetIsHovered(e == hoveredEntity);
}

int GameScene::FindEntityIndex(const std::string& id)
{
	for (size_t i = 0; i < Entities.size(); ++i)
		if (Entities[i]->GetID() == id)
			return static_cast<int>(i);

	return -1;
}

void GameScene::OnExit()
{
	for (Entity* entity : Entities)
		entity->OnExit();
}

void GameScene::OnUpdate(float deltaTime)
{
	for (Entity* entity : Entities)
	{
		if (entity->GetIsActive())
			entity->OnUpdate(deltaTime);
	}

	ResolveHover();

	if (!pendingSorts.empty())
	{
		for (auto& req : pendingSorts)
			SortEntity(req.id, req.target);

		pendingSorts.clear();
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
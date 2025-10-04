#include "FSM.h"

#include "../Game.h"
#include <algorithm>
#include <iostream>
#include <string>
#include "Entity.h"


bool FSM::Init()
{
	CurrentScene = ScenesMap[SceneID::Boot];
	CurrentScene->Initialize();

	return ScenesMap.size();
}

bool FSM::Deinit()
{
	for (const auto& kv : ScenesMap)
	{
		if (kv.second->IsInitialized())
		{
			kv.second->Deinitialize();
			std::cout << "Scene Layer: " << kv.first << " was not manually deinitialized" << std::endl;
		}
		delete kv.second;
	}

	ScenesMap.clear();

	return ScenesMap.empty();
}

void FSM::ChangeCurrent(const std::string& sceneId)
{
	GameScene* nextScene = ScenesMap[sceneId];

	if (nextScene == nullptr)			
		return;

	if (nextScene == CurrentScene)
		return;

	if (!nextScene->IsInitialized())	// So if We had initialized this scene then just return to it
		nextScene->Initialize();
	else
		nextScene->OnEnter();

	if (CurrentScene)
		CurrentScene->OnExit();
	
	CurrentScene = nextScene;
}

void FSM::Initialize(const std::string& sceneId)
{
	if (GameScene* nextScene = ScenesMap[sceneId])
	{
		if (!nextScene->IsInitialized())
			nextScene->Initialize();
		else
			std::cout << "Scene Layer: " << sceneId << " was already Initialized" << std::endl;
	}
}

void FSM::Deinitialize(const std::string& sceneId)
{
	if (GameScene* nextScene = ScenesMap[sceneId])
	{
		if (nextScene->IsInitialized())
			nextScene->Deinitialize();
		else
			std::cout << "Scene Layer: " << sceneId << " was Deinitialized" << std::endl;
	}
}

void FSM::ChangeEntityScene(const std::string& EntityId, const std::string& newSceneId)
{
	auto match = [&](Entity* e) { return e->Info.NameId == EntityId; }; // Find Id match

	for (auto& [key, prevScene] : ScenesMap)
	{
		std::vector<Entity*>& entities = prevScene->Entities;
		auto it = std::find_if(prevScene->Entities.begin(), prevScene->Entities.end(), match);

		if (it != entities.end())
		{
			if (GameScene* nextScene = ScenesMap[newSceneId])
			{
				entities.push_back(*it);						// if valid push into new Scene
				entities.erase(it);								// erase from old one using iterator
			}

			return;
		}
	}
}

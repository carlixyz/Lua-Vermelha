#include "FSM.h"

#include "../Game.h"
#include <algorithm>
#include <iostream>
#include <string>
#include "SceneFactory.h"
#include "Entity.h"
#include "../../Graphics/Graphics.h"

bool FSM::Init()
{
	SceneFactory factory;
	ScenesMap = factory.LoadAllScenes("data/Scripts/scenes.lua");

	if (ScenesMap.empty())
		return false;

	if (ScenesMap.contains(factory.GetStartSceneID()))
	{
		if (GameScene* startScene = ScenesMap[factory.GetStartSceneID()])
			if (CurrentScene = startScene)
				CurrentScene->Initialize();
	}
	else std::cout << "[FSM] StartScene '" << factory.GetStartSceneID() << "' not found. Falling back.\n";

	if (ScenesMap.contains(factory.GetSharedSceneID()))
	{
		if (GameScene* sharedScene = ScenesMap[factory.GetSharedSceneID()])
			if (SharedScene = sharedScene)
				SharedScene->Initialize();
	}
	else std::cout << "[FSM] SharedScene '" << factory.GetSharedSceneID() << "' not found!\n";

	for (auto& sceneIt : ScenesMap)
	{
		if (CurrentScene && sceneIt.second == CurrentScene)
			std::cout << "\t > Scene: " << sceneIt.first.c_str() << std::endl;
		else if(SharedScene && sceneIt.second == SharedScene)
			std::cout << "\t * Scene: " << sceneIt.first.c_str() << std::endl;
		else
			std::cout << "\t   Scene: " << sceneIt.first.c_str() << std::endl;

		ScenesArray.push_back(sceneIt.second);

		for (Entity* entity : sceneIt.second->Entities)
			std::cout << "\t\t - Entity: " << entity->GetInfo().NameId << std::endl;
	}

	return true;
}

bool FSM::Deinit()
{
	for (const auto& kv : ScenesMap)
	{
		if (kv.second->IsInitialized())
		{
			kv.second->Deinitialize();
			std::cout << "Scene Layer: " << kv.first << " was not manually Deinitialized" << std::endl;
		}
		delete kv.second;
	}

	ScenesMap.clear();

	ScenesArray.clear();

	return ScenesMap.empty();
}

void FSM::Update(float deltaTime)
{
	if (CurrentScene)
		CurrentScene->OnUpdate(deltaTime);

	if (SharedScene)
		SharedScene->OnUpdate(deltaTime);
}

void FSM::SwapDebugScenes()
{
	if (ScenesArray.empty())
		return;

	DrawText(TextFormat("Scene: %d - %s", SceneIndex, SceneID.c_str()), 32, 32, 16, YELLOW);

	if (IsKeyPressed(KEY_KP_ADD))
		SceneIndex = (int)Wrap((float)(SceneIndex + 1),
			0.0f, (float)ScenesArray.size());

	if (IsKeyPressed(KEY_KP_SUBTRACT))
		SceneIndex = (int)Wrap((float)(SceneIndex - 1),
			0.0f, (float)ScenesArray.size());

	if (GameScene* newScene = ScenesArray[SceneIndex])
		if (newScene != GetCurrent())
			for (auto& kv : ScenesMap)
				if (newScene == kv.second)
					ChangeCurrent(kv.first);
}

void FSM::Render()
{
	if (CurrentScene)
		CurrentScene->OnRender();

	if (SharedScene)
		SharedScene->OnRender();

	if (IsKeyPressed(KEY_KP_MULTIPLY))
		DebugScenes = !DebugScenes;

	if (DebugScenes)
		SwapDebugScenes();
}


void FSM::ChangeCurrent(const std::string& sceneId)
{

	if (!ScenesMap.contains(sceneId))
	{
		std::cerr << "\n [ERROR] Invalid sceneId: " << sceneId << std::endl;
		throw std::runtime_error("Error: invalid sceneId");
		return;
	}

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
	
	for (int i = 0; i < ScenesArray.size(); i++)
		if (ScenesArray[i] == nextScene) { SceneIndex = i; break; }

	SceneID = sceneId;

	CurrentScene = nextScene;
}

void FSM::Initialize(const std::string& sceneId)
{
	if (GameScene* initScene = ScenesMap[sceneId])
	{
		if (!initScene->IsInitialized())
			initScene->Initialize();
		else
			std::cout << "Scene Layer: " << sceneId << " was already Initialized" << std::endl;
	}
}

void FSM::Deinitialize(const std::string& sceneId)
{
	if (GameScene* deinitScene = ScenesMap[sceneId])
	{
		if (deinitScene->IsInitialized())
			deinitScene->Deinitialize();
		else
			std::cout << "Scene Layer: " << sceneId << " was already Deinitialized" << std::endl;
	}
}

void FSM::ChangeEntityScene(const std::string& EntityId, const std::string& newSceneId)
{
	if (newSceneId.empty() || !ScenesMap.contains(newSceneId))
	{
		std::cerr << "\n [ERROR] Invalid sceneId: " << newSceneId << std::endl;
		throw std::runtime_error("Error: invalid sceneId");
		return;
	}

	auto match = [&](Entity* e) { return e->Info.NameId == EntityId; }; // Find Id match

	for (auto& [key, prevScene] : ScenesMap)
	{
		std::vector<Entity*>& entities = prevScene->Entities;
		auto it = std::find_if(prevScene->Entities.begin(), prevScene->Entities.end(), match);

		if (it != entities.end())
		{
			if (GameScene* nextScene = ScenesMap[newSceneId])
			{
				if (prevScene == nextScene)
				{
					std::cout << "\n [ERROR] Entity :" << EntityId << " is already in sceneId : " << newSceneId << std::endl;
					return;
				}

				nextScene->Entities.push_back(*it);						// if valid push into new Scene
				//entities.push_back(*it);						// if valid push into new Scene
				entities.erase(it);								// erase from old one using iterator
			}

			return;
		}
	}
}

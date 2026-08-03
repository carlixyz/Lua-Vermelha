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
		if (GameScene* startScene = ScenesMap.at(factory.GetStartSceneID()))
			if (CurrentScene = startScene)
				CurrentScene->Initialize();
	}
	else std::cout << "[FSM] StartScene '" << factory.GetStartSceneID() << "' not found. Falling back.\n";

	if (ScenesMap.contains(factory.GetSharedSceneID()))
	{
		if (GameScene* sharedScene = ScenesMap.at(factory.GetSharedSceneID()))
			if (SharedScene = sharedScene)
				SharedScene->Initialize();
	}
	else std::cout << "[FSM] SharedScene '" << factory.GetSharedSceneID() << "' not found!\n";

	if (ScenesMap.contains(SceneID::Credits))
	{
		if (GameScene* creditScene = ScenesMap.at(SceneID::Credits))
			if (CreditsScene = creditScene)
				CreditsScene->Initialize();
	}
	else std::cout << "[FSM] Credits scene not found!\n";

	if (ScenesMap.contains(SceneID::Inventory))
	{
		if (InventoryScene = ScenesMap.at(SceneID::Inventory))
		{
			if (Inventory* invScene = (Inventory*)InventoryScene)
				invScene->BindWorldScene(&CurrentScene);
			else
				std::cout << "[FSM] Inventory scene is not of type Inventory.\n";

			InventoryScene->Initialize();
		}
	}
	else std::cout << "[FSM] Inventory '" << InventoryScene << "' not found!\n";

	int SceneArrayIndex = 0;
	for (auto& sceneIt : ScenesMap)
	{
		if (CurrentScene && sceneIt.second == CurrentScene)
			std::cout << "\t > Scene: " << sceneIt.first.c_str() << std::endl;
		else if(SharedScene && sceneIt.second == SharedScene)
			std::cout << "\t * Scene: " << sceneIt.first.c_str() << std::endl;
		else
			std::cout << "\t   Scene: " << sceneIt.first.c_str() << std::endl;

		ScenesArray.push_back(sceneIt.second);

		if (sceneIt.first == factory.GetStartSceneID())
			SceneIndex = SceneArrayIndex;
		SceneArrayIndex++;

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
	ProcessMarkedEntities();

	if (CurrentScene)
		CurrentScene->OnUpdate(deltaTime);

	if (SharedScene)
		SharedScene->OnUpdate(deltaTime);

	if (InventoryScene)
		InventoryScene->OnUpdate(deltaTime);

	if (CreditsScene)
		CreditsScene->OnUpdate(deltaTime);
}

void FSM::ProcessMarkedEntities()
{
	for (const PendingEntityOperation& operation : PendingEntityOperations)
	{
		if (!operation.Source || !operation.Pointer)
			continue;

		auto& entities = operation.Source->Entities;
		auto it = std::find(entities.begin(), entities.end(), operation.Pointer);

		if (it == entities.end())
			continue;

		if (operation.MarkedForRemoval)
		{
			operation.Pointer->OnDeinit();
			delete operation.Pointer;
		}
		else if (operation.Target)
		{
			operation.Target->Entities.push_back(operation.Pointer);
		}

		entities.erase(it);
	}

	PendingEntityOperations.clear();
}

void FSM::SwapDebugScenes()
{
	if (ScenesArray.empty())
		return;

	DrawText(TextFormat("Scene: %d - %s", SceneIndex, SceneID.c_str()), 32, 32, 16, YELLOW);

	if (IsKeyPressed(KEY_KP_ADD))
		SceneIndex = (int)Wrap((float)(SceneIndex + 1), 0.0f, (float)ScenesArray.size());

	if (IsKeyPressed(KEY_KP_SUBTRACT))
		SceneIndex = (int)Wrap((float)(SceneIndex - 1), 0.0f, (float)ScenesArray.size());

	if (GameScene* newScene = ScenesArray[SceneIndex])
	{
		if (newScene != GetCurrent())
			for (auto& kv : ScenesMap)
				if (newScene == kv.second)
					ChangeCurrent(kv.first);

		for (int i = 0, t = (int)newScene->Entities.size(); i < t; i++)
		{
			if (Entity* entity = newScene->Entities[i])
				DrawText(TextFormat("\t\t -> %s - %02.01f - %s", 
					entity->GetInfo().NameId.c_str(), 
					entity->GetInfo().Alpha, 
					entity->GetInfo().Visible ? "on" : "off"),
					32, 64 + (32 * i), 16, YELLOW);
		}
	}

	DrawText(TextFormat("[%i, %i]", GetMouseX(), GetMouseY()), GetMouseX()-64, GetMouseY() -16, 16, YELLOW);
}

void FSM::Render()
{
	if (CurrentScene)
		CurrentScene->OnRender();

	if (SharedScene)
		SharedScene->OnRender();

	/// Game::Get().RenderCursor();

	if (InventoryScene)
		InventoryScene->OnRender();

	if (CreditsScene)
		CreditsScene->OnRender();

	if (IsKeyPressed(KEY_KP_MULTIPLY))
		DebugScenes = !DebugScenes;

	if (DebugScenes)
		SwapDebugScenes();
}


void FSM::ChangeCurrent(const std::string& sceneId)
{
	if (!ScenesMap.contains(sceneId))
	{
#ifdef _DEBUG
		std::string msg = "[ERROR] Invalid sceneId : " + sceneId + " not created!\n \n ";
		Graphics::Get().ShowPopup(msg, 5.0f);
#endif
		std::cout << "\n [ERROR] Invalid sceneId: " << sceneId << std::endl << std::endl;
		//throw std::runtime_error("Error: invalid sceneId");
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

bool FSM::IsEntityInScene(const std::string& EntityId, const std::string& SceneId)
{
	if (SceneId.empty() || !ScenesMap.contains(SceneId))
	{
		std::cout << "\n [ERROR] Invalid sceneId: " << SceneId << std::endl;
		throw std::runtime_error("Error: invalid sceneId");
		return false;
	}

	return ScenesMap[SceneId]->FindEntityIndex(EntityId) != -1; // If -1 then it's not present here
}

void FSM::DisableEntity(const std::string& id)
{
	for (auto& [sceneName, scene] : ScenesMap)
		for(auto& e : scene->Entities)
			if (e->GetID() == id)
			{
				e->SetIsVisible(false);
				e->SetIsActive(false);
				e->SetIsClickable(false);
			}
}

void FSM::RemoveEntity(const std::string& entityId)
{
	for (auto& [sceneName, scene] : ScenesMap)
	{
		if (!scene)
			continue;

		auto& entities = scene->Entities;

		auto it = std::find_if(entities.begin(), entities.end(),
			[&](Entity* entity) { return entity && entity->GetID() == entityId; });

		if (it == entities.end())
			continue;

		PendingEntityOperations.push_back({ scene, nullptr, *it, true });
		return;
	}

	std::cout << "[FSM] Entity '" << entityId << "' not found for removal\n";
}

void FSM::ChangeEntityScene(const std::string& entityId, const std::string& newSceneId)
{
	if (newSceneId.empty() || !ScenesMap.contains(newSceneId))
	{
		std::cout << "\n[ERROR] Invalid sceneId: " << newSceneId << std::endl;
		return;
	}

	GameScene* nextScene = ScenesMap.at(newSceneId);

	for (auto& [sceneName, previousScene] : ScenesMap)
	{
		if (!previousScene)
			continue;

		auto& entities = previousScene->Entities;

		auto it = std::find_if(entities.begin(), entities.end(),
			[&](Entity* entity) { return entity && entity->GetID() == entityId; });

		if (it == entities.end())
			continue;

		if (previousScene == nextScene)
		{
			std::cout << "\n[ERROR] Entity: " << entityId << " is already in sceneId: " << newSceneId << std::endl;
			return;
		}

		PendingEntityOperations.push_back({ previousScene, nextScene, *it, false });
		return;
	}

	std::cout << "[FSM] Entity '" << entityId << "' not found for Scene move\n";
}

void FSM::ChangeEntityToFront(const std::string& EntityId, int offset)
{
	for (auto& [key, Scene] : ScenesMap)
		if (Scene->FindEntityIndex(EntityId) >= 0)
		{
			Scene->RequestMoveFront(EntityId, offset);
			return;
		}
}

void FSM::ChangeEntityToBack(const std::string& EntityId, int offset)
{
	for (auto& [key, Scene] : ScenesMap)
		if (Scene->FindEntityIndex(EntityId) >= 0)
		{
			Scene->RequestMoveBack(EntityId, offset);
			return;
		}
}


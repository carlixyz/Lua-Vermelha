#pragma once

#include "GameScene.h"
#include "BootState.h"
#include "TestScene.h"
#include "Inventory.h"
#include "Credits.h"
#include "Status.h"

#include <stack>
#include <map>
#include <vector>
#include <assert.h>
#include <string_view>

struct SceneID 
{
	#define SCENE_ID(name) static constexpr const char* name = #name;
	//static constexpr const char* Boot = "Boot";
	 
	SCENE_ID(Boot)
	SCENE_ID(Global)
	SCENE_ID(Road)
	SCENE_ID(Intro)
	SCENE_ID(Inventory)
	SCENE_ID(Title)
	SCENE_ID(Status)
	SCENE_ID(Credits)
	SCENE_ID(Test)
	SCENE_ID(Mansion)
};
 

class SceneFactory;

class FSM	/// Finite Scene Manager ftw!
{
	std::map<std::string, GameScene*> ScenesMap;
	GameScene* CurrentScene		= nullptr;							// &bootState;
	GameScene* SharedScene		= nullptr;
	GameScene* InventoryScene	= nullptr;
	GameScene* CreditsScene		= nullptr;
	GameScene* StatusScene		= nullptr;

	bool DebugScenes = false;
	int SceneIndex = 0;
	std::string SceneID = "";
	std::vector<GameScene*> ScenesArray;						// Internal use Only
	void SwapDebugScenes();

	friend SceneFactory;

	struct PendingEntityOperation
	{
		GameScene* Source = nullptr;
		GameScene* Target = nullptr;
		Entity* Pointer = nullptr;
		bool MarkedForRemoval = false;
	};

	std::vector<PendingEntityOperation> PendingEntityOperations;

	void ProcessMarkedEntities();

public:

	bool Init();
	bool Deinit();

	void Update(float deltaTime);
	void Render();

	void Initialize(const std::string& sceneId);
	void Deinitialize(const std::string& sceneId);

	void ChangeCurrent(const std::string& sceneId);
	void ChangeEntityScene(const std::string& entityId, const std::string& newSceneId);
	bool IsEntityInScene(const std::string& entityId, const std::string& SceneId);
	void DisableEntity(const std::string& entityId);
	void RemoveEntity(const std::string& entityId);

	void ChangeEntityToFront(const std::string& EntityId, int offset = 0);
	void ChangeEntityToBack(const std::string& EntityId, int offset = 0);

	GETTERSETTER(GameScene*, Current, CurrentScene);			// return current scene layer
	GETTERSETTER(GameScene*, Shared, SharedScene);				// return shared scene layer
	GETTERSETTER(GameScene*, Inventory, InventoryScene);		// return Inventory scene layer
	GETTERSETTER(GameScene*, Credits, CreditsScene);			// return Credits scene layer
	GETTERSETTER(GameScene*, Status, StatusScene);				// return Status scene layer
};


#pragma once

#include "GameScene.h"
#include "BootState.h"
#include "TestScene.h"

#include <stack>
#include <map>
#include <assert.h>
#include <string_view>

struct SceneID 
{
	#define SCENE_ID(name) static constexpr const char* name = #name;
	//static constexpr const char* Boot = "Boot";
	 
	SCENE_ID(Boot)
	SCENE_ID(Global)
	SCENE_ID(Test)
	SCENE_ID(Intro)
	SCENE_ID(Mansion)
	SCENE_ID(Title)
	SCENE_ID(Credits)
};

class SceneFactory;

class FSM	/// Finite Scene Manager ftw!
{
	std::map<std::string, GameScene*> ScenesMap;
	GameScene* CurrentScene = nullptr; // &bootState;
	GameScene* SharedScene = nullptr;

	friend SceneFactory;

public:
	bool Init();
	bool Deinit();

	void Initialize(const std::string& sceneId);
	void Deinitialize(const std::string& sceneId);
	void ChangeCurrent(const std::string& sceneId);
	void ChangeEntityScene(const std::string& EntityId, const std::string& newSceneId);


	GETTERSETTER(GameScene&, Current, *CurrentScene);			// return current scene layer
	GETTERSETTER(GameScene&, Shared, *SharedScene);				// return shared scene layer

	//inline GameScene& GetCurrent()	{ return *CurrentScene; } 	// return current scene layer
	//inline GameScene& GetShared()	{ return *SharedScene; }	

};


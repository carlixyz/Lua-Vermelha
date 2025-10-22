#pragma once

#include "InstanceBase.h"
#include <vector>
#include <string>
#include "raylib.h"

class Entity;

class GameScene : public InstanceBase ///, public LuaInterface
{
	bool initialized = false;

	///std::string SceneID;

	///virtual void OnReturn() override;

protected:

	void Initialize()	{ initialized = true; OnInit(); } 	// Lazy Initialization just once
	void Deinitialize() { OnDeinit(); initialized = false; }

	friend class FSM;										// but still restricted via methods

	virtual void OnInit() override;
	virtual void OnDeinit() override;

	virtual void OnExit() override;
	virtual void OnEnter() override;

public:
	///GameScene(const std::string& scriptPath) : LuaInterface(scriptPath) { Call("OnConstruct"); }


	virtual void OnUpdate(float deltaTime) override;
	virtual void OnRender() override;

	bool IsInitialized() const { return initialized; }

	std::vector<Entity*> Entities;
};


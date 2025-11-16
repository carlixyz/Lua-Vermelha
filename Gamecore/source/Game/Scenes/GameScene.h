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

	struct MoveRequest 
	{
		std::string id;
		int target;
	};

	std::vector<MoveRequest> pendingSorts;
	void SortEntity(const std::string& id, int newIndex);

protected:

	void Initialize()	{ initialized = true; OnInit(); } 	// Lazy Initialization just once
	void Deinitialize() { OnDeinit(); initialized = false; }

	friend class FSM;										// but still restricted via methods

	virtual void OnInit() override;
	virtual void OnDeinit() override;

	virtual void OnExit() override;
	virtual void OnEnter() override;

public:

	int FindEntityIndex(const std::string& id);
	void RequestMoveFront(const std::string& id, int offset = 0);
	void RequestMoveBack(const std::string& id, int offset = 0);

	virtual void OnUpdate(float deltaTime) override;
	virtual void OnRender() override;

	bool IsInitialized() const { return initialized; }

	std::vector<Entity*> Entities;
};


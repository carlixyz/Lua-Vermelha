#pragma once

#include "InstanceBase.h"
#include <vector>

class Entity;

class GameScene : public InstanceBase
{
	bool initialized = false;

protected:

	void Initialize()	{ initialized = true; OnInit(); } 	// Lazy Initialization just once
	void Deinitialize() { OnDeinit(); initialized = false; }

	friend class FSM;										// but still restricted via methods

	virtual void OnInit() override;
	virtual void OnDeinit() override;

	virtual void OnExit() override;
	virtual void OnEnter() override;

public:
	virtual void OnUpdate() override;
	virtual void OnRender() override;

	bool IsInitialized() const { return initialized; }

	std::vector<class Entity*> Entities;
};


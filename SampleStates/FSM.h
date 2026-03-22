#pragma once

#include "GameState.h"
#include "DialogState.h"
#include "IntroState.h"
#include "BootState.h"
#include "TitleState.h"
#include "RoadState.h"
#include <stack>
#include <assert.h>

class FSM	/// Finite State Machine ftw!
{
	std::stack<GameState*> statesStack; 

public:
	bool Init(GameState& state);
	bool Init();
	bool Deinit();

	void ChangeState(GameState& state);
	void PushState(GameState& state);
	void PopState();
	
	//inline bool IsLoaded()				{ return !statesStack.empty(); }

	inline GameState& CurrentState()	
	{
		assert(!statesStack.empty());
		return *statesStack.top(); 
	}

	/// All states instances included below here
	BootState bootState;
	IntroState introState;
	TitleState titleState;
	RoadState roadState;
	DialogState dialogState;
};


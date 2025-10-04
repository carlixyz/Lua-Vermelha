#pragma once

#include "../Utility/Singleton.h"
#include "../Graphics/ApplicationProperties.h"
#include "Scenes/FSM.h"


class Game : public Singleton<Game>
{
	bool finish = false;


public:
	friend class Singleton<Game>;
	ApplicationProperties appProperties;
	FSM Scenes;

	bool Init();
	void Update();

	void Render();
	bool Deinit();

	inline bool HasFinished() const	{ return finish; }
	//inline bool IsDebugMode() const { return appProperties.DebugMode; }
	//inline bool SkipIntro()	  const { return appProperties.SkipIntro; }

protected:
	Game() { ; } // Protected Constructor

};



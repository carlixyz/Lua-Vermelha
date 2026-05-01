#pragma once

#include "../Utility/Singleton.h"
#include "../Graphics/ApplicationProperties.h"
#include "Scenes/FSM.h"


class Game : public Singleton<Game>
{
	bool finish = false;

	bool debug = false;

	bool mouseCaptured = false;

public:
	friend class Singleton<Game>;
	ApplicationProperties appProperties;
	FSM Scenes;

	bool Init();
	void Update(float deltaTime);

	void Render();
	bool Deinit();

	void RenderCursor();


	inline bool HasFinished()		const	{ return finish; }
	inline bool IsDebugMode()		const { return debug; }
	inline bool IsAudioEnabled()	const { return !appProperties.AudioDisabled; }
	inline bool IsAudioDisabled()	const { return !IsAudioEnabled(); }
	//inline bool SkipIntro()	  const { return appProperties.SkipIntro; }

protected:
	Game() { ; } // Protected Constructor
};



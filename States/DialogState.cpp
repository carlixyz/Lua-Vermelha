#include "DialogState.h"
//#include "../ConversationManager.h"
//#include "../VisualDialogManager.h"


void DialogState::OnInit()
{
	//ConversationManager::Get().Init(Game::Get().appProperties.DialogFilePath); // .Init("Data/dialogTest.yml");
	//ConversationManager::Get().StartConversation("IntroSchool");
}

void DialogState::OnDeinit()
{
	//VisualDialogManager::Get().UnLoadAll();
}


void DialogState::OnUpdate()
{
	//if (!ConversationManager::Get().IsInConversation())
	//{
	//	Game::Get().States.PopState();
	//}
}

void DialogState::OnRender()
{
}

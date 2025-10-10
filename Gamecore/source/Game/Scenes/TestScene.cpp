#include "TestScene.h"

#include "../Game.h"
#include "../../Graphics/Graphics.h"
#include "./reasings.h"
#include "Entity.h"

void TestScene::OnInit()
{

	//Entities.push_back(new Entity("data/Scripts/elder.lua"));
	//Entities.push_back(new Entity("data/Scripts/fountain.lua"));
	//Entities.push_back(new Entity("data/Scripts/door.lua"));

	GameScene::OnInit();		//Entity->OnInit();
}

void TestScene::OnDeinit()
{
	GameScene::OnDeinit();
}

void TestScene::OnUpdate()
{
	GameScene::OnUpdate();

}

void TestScene::OnRender()
{

	GameScene::OnRender();

}


//void TestScene::OnExit()
//{
//}

//void TestScene::OnEnter()
//{
//}

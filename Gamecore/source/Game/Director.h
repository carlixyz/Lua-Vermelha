#pragma once

#include "../Utility/Singleton.h"
#include "Scenes/Entity.h"
#include "Scenes/FSM.h"
#include "Assets.h"
#include "../Lua/LuaManager.h"
#include <iostream>
#include <functional>
#include <unordered_map>

class Director : public Singleton<Director> 
{
    friend class Singleton<Director>;

    std::unordered_map<std::string, Entity*> Entities; // Global registry

public:
    
    void Init();

    void Deinit();

    Entity* CreateEntity(const std::string& type, const std::string& scriptPath);

    Entity* GetEntity(const std::string& id);

    void RegisterEntity(Entity* entity);

    void RequestAction(const std::string& id, const std::function<void(Entity*)>& action);

    void SetEntityTexture(const std::string& nameID, const std::string& textureID);

    void SetEntityActive(const std::string& nameID, bool active = true);

    void SetEntityVisible(const std::string& nameID, bool visible = true);

    void SetEntityPosition(const std::string& nameID, float x, float y);


    //void SetEntityScene(const std::string& nameID, const std::string& targetSceneID);


    //void CueScene(const std::string& scene) 
    //{
    //    FSM::Get().ChangeScene(scene);
    //}

    //void ShowDialog(const std::string& text) 
    //{
    //    std::cout << "[Dialog] " << text << "\n";
    //    // Could connect with Lua coroutine or DialogueManager
    //}

    //void PlaySound(const std::string& soundId) 
    //{
    //    std::cout << "[Director] Play sound: " << soundId << "\n";
    //    PlaySound(GetSound(soundId));
    //}

    //void FadeMusic(const std::string& name, float duration) 
    //{
    //    std::cout << "[Director] Fading music: " << name << " in " << duration << " seconds\n";
    //}
};



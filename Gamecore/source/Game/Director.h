#pragma once

#include "../Utility/Singleton.h"
#include "Scenes/Entity.h"
#include "Scenes/FSM.h"
#include "Assets.h"
#include <iostream>
#include <functional>
#include <unordered_map>

struct ScheduledTask
{
    std::string Id;
    float RemainingTime;
    std::function<void()> Callback;
    bool Repeat;
    float Interval;
    bool Cancelled = false;

    ScheduledTask(const std::string& id, float delay, const std::function<void()>& cb, bool repeat = false)
        : Id(id), RemainingTime(delay), Callback(cb), Repeat(repeat), Interval(delay) {
    }
};


class Director : public Singleton<Director> 
{
    friend class Singleton<Director>;

    std::unordered_map<std::string, Entity*> Entities; // Global registry

    std::vector<ScheduledTask> PendingTasks;
    bool IsIterating = false;

    std::vector<ScheduledTask> ScheduledTasks;

    std::unordered_map<std::string, std::function<void(std::vector<std::string>)>> FunctionMap;

public:
    
    bool Init();

    bool Deinit();

    void Update(float dt);

    void InitFunctionMap();

    void CallFunction(const std::string& name, const std::vector<std::string>& args);

    std::string Schedule(float delay, const std::function<void()>& func, bool repeat = false, const std::string& id = "");

    void CancelScheduledTask(const std::string& id);


    Entity* CreateDummyEntity(const SpriteInfo& data);

    Entity* CreateEntity(const std::string& type, const std::string& scriptPath);

    Entity* CreateEntityInline(const std::string& type, int tableIndex);

    Entity* GetEntity(const std::string& id);



    void StartSequence(const std::string& sequenceID);

    void RegisterEntity(Entity* entity);

    void RegisterLuaGlobal(const std::string& name, Entity* entity);

    void RequestAction(const std::string& id, const std::function<void(Entity*)>& action);

    void SetEntityTexture(const std::string& nameID, const std::string& textureID);

    void SetEntityActive(const std::string& nameID, bool active = true);

    void SetEntityAlpha(const std::string& nameID, float alpha = 1.0f);

    float GetEntityAlpha(const std::string& nameID);

    void SetEntityVisible(const std::string& nameID, bool visible = true);

    void SetEntityClickable(const std::string& nameID, bool visible = true);

    void SetEntityPosition(const std::string& nameID, float x, float y);

    void MoveEntity(const std::string& nameID, float x, float y, float lapse = 3.0f);

    void FadeEntity(const std::string& nameID, float startValue, float endValue, float totalTime = 3.0f);

    void ShakeEntity(const std::string& nameID, float amount, float totalTime);

    void StopEntity(const std::string& nameID);




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



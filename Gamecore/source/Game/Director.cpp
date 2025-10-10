#include "Director.h"

#include "Scenes/Entity.h"
#include "Assets.h"
#include <raylib-cpp.hpp>


void Director::Init()
{
    std::cout << "[Director] Online.\n";
}

void Director::Deinit()
{
    Entities.clear();
    std::cout << "[Director] Offline.\n";
}

Entity* Director::CreateEntity(const std::string& type, const std::string& scriptPath)
{
    Entity* entity = nullptr;

    /// --- Special subclass handling ---

    //if (type == "Door")
    //    entity = new Entity(scriptPath); // Door subclass later
    //else if (type == "Background")
    //    entity = new Entity(scriptPath); // Background subclass later
    //else
    //  entity = new Entity(scriptPath); // Fallback
        
    entity = new Entity(scriptPath); // Fallback

    RegisterEntity(entity);

	return entity;
}

void Director::RegisterEntity(Entity* entity)
{
    if (!entity)
        return;

    const std::string& nameId = entity->GetInfo().NameId;

    if (Entities.contains(nameId))
        return;

    if (nameId.empty())
        return;

    Entities[nameId] = entity;
}

Entity* Director::GetEntity(const std::string& id)
{
    auto it = Entities.find(id);
    return it != Entities.end() ? it->second : nullptr;
}

void Director::RequestAction(const std::string& id, const std::function<void(Entity*)>& action)
{
    if (Entity* e = GetEntity(id))
        action(e);
    else
        std::cerr << "[Director] Entity not found: " << id << "\n";
}

void Director::SetEntityTexture(const std::string& nameID, const std::string& textureID)
{
    if (Entity* entity = Director::Get().GetEntity(nameID))
    {
        entity->SetSprite(textureID);
    }
}

void Director::SetEntityActive(const std::string& nameID, bool active)
{
    if (Entity* entity = Director::Get().GetEntity(nameID))
    {
        entity->SetIsActive(active);
    }
}

void Director::SetEntityVisible(const std::string& nameID, bool visible)
{
    if (Entity* entity = Director::Get().GetEntity(nameID))
    {
        entity->SetIsActive(visible);
    }
}

void Director::SetEntityPosition(const std::string& nameID, float x, float y)
{
    if (Entity* entity = Director::Get().GetEntity(nameID))
    {
        entity->SetPositionX(x);
        entity->SetPositionX(y);
    }
}


//void Director::SetEntityScene(const std::string& entityID, const std::string& targetSceneID)
//{
//    std::cout << "[SetEntityScene] " << entityID
//        << " moved to scene: " << targetSceneID << "\n";
//}

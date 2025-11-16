#include "Director.h"

#include "Assets.h"
#include "Scenes/Entity.h"
#include "Scenes/SceneFactory.h"
#include "../Lua/LuaManager.h"
#include <raylib-cpp.hpp>


bool Director::Init()
{
    std::cout << "[Director] Online.\n";
    InitFunctionMap();

    return true;
}

bool Director::Deinit()
{
    Entities.clear();
    std::cout << "[Director] Offline.\n";

    return true;
}

void Director::Update(float dt)
{
    IsIterating = true;

    for (auto it = ScheduledTasks.begin(); it != ScheduledTasks.end();)
    {
        if (it->Cancelled)
        {
            it = ScheduledTasks.erase(it);
            continue;
        }

        it->RemainingTime -= dt;

        if (it->RemainingTime <= 0.f)
        {
            // Run the task safely
            try
            {
                it->Callback();
            }
            catch (...)
            {
                std::cerr << "[Director] Exception inside scheduled callback\n";
            }

            if (it->Repeat && !it->Cancelled)
            {
                it->RemainingTime = it->Interval;
                ++it;
            }
            else
            {
                it = ScheduledTasks.erase(it);
            }
        }
        else
        {
            ++it;
        }
    }

    IsIterating = false;

    if (!PendingTasks.empty())
    {
        ScheduledTasks.insert(ScheduledTasks.end(),
            std::make_move_iterator(PendingTasks.begin()),
            std::make_move_iterator(PendingTasks.end()));
        PendingTasks.clear();
    }
}



void Director::InitFunctionMap()
{
    // ScheduleFunction(3.0, "FadeEntity", "John", "0.0", "1.0", "2.0")
    //FunctionMap["FadeEntity"] = [this](std::vector<std::string> args)
    //    {
    //        if (args.size() >= 4)
    //            FadeEntity(args[0], std::stof(args[1]), std::stof(args[2]), std::stof(args[3]));
    //    };

    // ScheduleFunction(3.0, "FadeEntity", "John", "0.0", "3.0")
    FunctionMap["FadeEntity"] = [this](std::vector<std::string> args)
    {
        if (args.size() >= 3)
        {
            float initialAlpha = GetEntityAlpha(args[0]);
            FadeEntity(args[0], initialAlpha, std::stof(args[1]), std::stof(args[2]));
        }
    };

    // ScheduleFunction(1.5, "MoveEntity", "Door", "100", "150", "4.0")
    FunctionMap["MoveEntity"] = [this](std::vector<std::string> args)
        {
            if (args.size() >= 3)
                MoveEntity(args[0], std::stof(args[1]), std::stof(args[2]),
                    args.size() >= 4 ? std::stof(args[3]) : 3.0f);
        };

    // ScheduleFunction(5.0, "SetEntityVisible", "Dark", "false")
    FunctionMap["SetEntityVisible"] = [this](std::vector<std::string> args)
        {
            if (args.size() >= 2)
                SetEntityVisible(args[0], args[1] == "true" || args[1] == "1");
        };

    // ScheduleFunction(5.0, "SetEntityAlpha", "Dark", "0.5")
    FunctionMap["SetEntityAlpha"] = [this](std::vector<std::string> args)
        {
            if (args.size() >= 2)
                SetEntityAlpha(args[0], std::stof(args[1]));
        };

    // ScheduleFunction(5.0, "SetEntityActive", "Dark", "true")
    FunctionMap["SetEntityActive"] = [this](std::vector<std::string> args)
        {
            if (args.size() >= 2)
                SetEntityActive(args[0], args[1] == "true" || args[1] == "1");
        };

    // ScheduleFunction(5.0, "SetEntityClickable", "Dark", "false")
    FunctionMap["SetEntityClickable"] = [this](std::vector<std::string> args)
        {
            if (args.size() >= 2)
                SetEntityClickable(args[0], args[1] == "true" || args[1] == "1");
        };

    // ScheduleFunction(5.0, "FunctionMap", "Dark", "100", "150")
    FunctionMap["SetEntityPosition"] = [this](std::vector<std::string> args)
        {
            if (args.size() >= 3)
                SetEntityPosition(args[0], std::stof(args[1]), std::stof(args[2]));
        };

    // ScheduleFunction(5.0, "StartSequence", "FirstDialog")
    FunctionMap["StartSequence"] = [this](std::vector<std::string> args)
        {
            if (args.size() == 1)
                StartSequence(args[0]);
        };

    // ScheduleFunction(5.0, "SetEntityTexture", "Elder", "SadElder")
    FunctionMap["SetEntityTexture"] = [this](std::vector<std::string> args)
        {
            if (args.size() == 2)
                SetEntityTexture(args[0], args[1]);
        };
}

void Director::CallFunction(const std::string& name, const std::vector<std::string>& args)
{
    auto it = FunctionMap.find(name);
    if (it != FunctionMap.end())
        it->second(args);
    else
        std::cerr << "[Director] Unknown function scheduled: " << name << "\n";
}

std::string Director::Schedule(float delay, const std::function<void()>& func, bool repeat, const std::string& id)
{
    std::string realId =
        id.empty() ? ("task_" + std::to_string(ScheduledTasks.size() +
            PendingTasks.size() + 1))
        : id;

    ScheduledTask newTask(realId, delay, func, repeat);

    if (IsIterating)
        PendingTasks.push_back(std::move(newTask));
    else
        ScheduledTasks.push_back(std::move(newTask));

    return realId;
}

void Director::CancelScheduledTask(const std::string& id)
{
    for (auto& task : ScheduledTasks)
    {
        if (task.Id == id)
        {
            task.Cancelled = true;
            std::cout << "[Director] Cancelled task: " << id << "\n";
            break;
        }
    }
}


Entity* Director::CreateEntity(const SpriteInfo& data)
{
    /// Creates a Dummy 'scriptless' Entity
    Entity* e = new Entity();

    e->GetInfo().NameId = data.NameId;
    e->SetIsVisible(data.Visible);
    e->SetIsActive(data.Active);
    e->SetIsClickable(data.Clickable);
    e->SetAlpha( data.Alpha);
    e->SetPositionX((int)data.PositionX);
    e->SetPositionY((int)data.PositionY);


    // Copy the texture ID list (Assets were loaded in SpriteFromLua)
    e->GetInfo().TexturesIDs = data.TexturesIDs;

    // Choose current image = first ID if any
    const std::string& TextId = 
        (!e->GetInfo().TexturesIDs.empty() ? e->GetInfo().TexturesIDs[0] : e->GetID());

    e->SetSprite(TextId);

    RegisterEntity(e);

    return e;
}


Entity* Director::CreateEntity(const std::string& type, const std::string& scriptPath)
{
    /// Creates a scripted Entity
    Entity* entity = nullptr;

    /// --- Special subclass handling ---
    if (type == "Quad")
        entity = new Quad(scriptPath); // Simple HitBox simplification
    else
        entity = new EntityLua(scriptPath); // Fallback

    RegisterEntity(entity);

	return entity;
}

Entity* Director::CreateEntityInline(const std::string& type, int tableIndex)
{
    /// Creates a inline Entity from a embed lua script 
    Entity* entity = nullptr;

    /// --- Special subclass handling ---
    if (type == "Quad")
        entity = new Quad(tableIndex); // Simple HitBox simplification
    else
        entity = new EntityLua(tableIndex); // Fallback
    
    RegisterEntity(entity);

    if (EntityLua* eLua = (EntityLua*)entity)
    {
        lua_State* L = LuaManager::Get().GetState();
        lua_rawgeti(L, LUA_REGISTRYINDEX, eLua->GetRef());   // push entity table
        lua_setglobal(L, type.c_str());                   // _G[type] = entity_table
    }

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

void RegisterEntityInLua(const std::string& name, int luaRef)
{
    lua_State* L = LuaManager::Get().GetState();

    // Ensure global "Entities" table exists
    lua_getglobal(L, "Globals");
    if (!lua_istable(L, -1))
    {
        lua_pop(L, 1);        // pop nil
        lua_newtable(L);      // create Globals = {}
        lua_pushvalue(L, -1); // duplicate
        lua_setglobal(L, "Globals");
    }

    // Entities[name] = <entity_table>
    lua_pushstring(L, name.c_str());
    lua_rawgeti(L, LUA_REGISTRYINDEX, luaRef);
    lua_settable(L, -3);

    // Pop Entities table
    lua_pop(L, 1);
}

Entity* Director::GetEntity(const std::string& id)
{
    auto it = Entities.find(id);

    if (it != Entities.end())
        return it->second;
    else
        std::cout << "[Director] Entity not found: " << id << "\n";

    return nullptr;
}

void Director::RequestAction(const std::string& id, const std::function<void(Entity*)>& action)
{
    if (Entity* e = GetEntity(id))
        action(e);
    else
        std::cout << "[Director] Entity not found: " << id << "\n";
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

float Director::GetEntityAlpha(const std::string& nameID)
{
    if (Entity* entity = Director::Get().GetEntity(nameID))
    {
        return entity->GetAlpha();
    }

    return 0.0f;
}

void Director::SetEntityAlpha(const std::string& nameID, float alpha)
{
    if (Entity* entity = Director::Get().GetEntity(nameID))
    {
        entity->SetAlpha(alpha);
    }
}

void Director::SetEntityVisible(const std::string& nameID, bool visible)
{
    if (Entity* entity = Director::Get().GetEntity(nameID))
    {
        entity->SetIsVisible(visible);
    }
}

void Director::SetEntityClickable(const std::string& nameID, bool visible)
{
    if (Entity* entity = Director::Get().GetEntity(nameID))
    {
        entity->SetIsClickable(visible);
    }
}

void Director::SetEntityPosition(const std::string& nameID, float x, float y)
{
    if (Entity* entity = Director::Get().GetEntity(nameID))
    {
        entity->SetPositionX((int)x);
        entity->SetPositionY((int)y);
    }
}

void Director::MoveEntity(const std::string& nameID, float x, float y, float lapse)
{
    if (Entity* entity = Director::Get().GetEntity(nameID))
    {
        Vector2 initialPos { (float)entity->GetPositionX(), (float)entity->GetPositionY()};
        entity->GetTween().ActionMove(initialPos, { x, y }, lapse);
    }
}

void Director::StartSequence(const std::string& sequenceID)
{
    LuaManager::Get().StartSequence(sequenceID);
}


void Director::FadeEntity(const std::string& nameID, float startValue, float endValue, float totalTime)
{
    if (Entity* entity = Director::Get().GetEntity(nameID))
    {
        entity->GetTween().ActionFade(startValue, endValue, totalTime);;
    }
}


//void Director::SetEntityScene(const std::string& entityID, const std::string& targetSceneID)
//{
//    std::cout << "[SetEntityScene] " << entityID
//        << " moved to scene: " << targetSceneID << "\n";
//}

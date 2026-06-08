#include "LuaFunctions.h"

#include "LuaManager.h"
#include "../Graphics/Graphics.h"
#include "../Game/Assets.h"
#include "../Game/Director.h"
#include "../Game/Game.h"
#include "../Game/Scenes/Entity.h"
#include "../Game/Scenes/FSM.h"
#include "../Audio/Audio.h"

#include <raylib-cpp.hpp>

// Helper for stack trace
int traceback(lua_State* L) 
{
    const char* msg = lua_tostring(L, 1);
    if (msg)
        luaL_traceback(L, L, msg, 1);
    else
        lua_pushliteral(L, "(no error message)");
    return 1;
}


// Example native functions
int Lua_StartSequence(lua_State* L)
{
    if (lua_isstring(L, 1))
    {
        const std::string& sequenceID = luaL_checkstring(L, 1);
        LuaManager::Get().StartSequence(sequenceID);
    }
    else
        LuaManager::Get().StartSequence(L);

    return 0; // no Lua return values
}

int Lua_EndSequence(lua_State* L)
{
    if (!LuaManager::Get().IsSequenceRunning())
        std::cout << "[Lua_EndSequence] ForceEnd on Sequence already stopped" << std::endl;
    else
        LuaManager::Get().StopSequence();

    return 0;
}

int Lua_Say(lua_State* L)
{
    int argc = lua_gettop(L);

    if (argc == 0)
        return luaL_error(L, "Say(): missing arguments");

    if (argc == 1 && lua_isnil(L, 1))
    {
        // treat Say() as silent pause
        lua_newtable(L);
        lua_pushstring(L, "SAY");
        lua_setfield(L, -2, "type");
        return lua_yield(L, 1);
    }


    const char* speaker = nullptr;
    const char* text = nullptr;
    float duration = -1.0f;

    if (argc == 0)
    {
        // Say() > blank line or clear screen command
        lua_newtable(L);
        lua_pushstring(L, "SAY");
        lua_setfield(L, -2, "type");
        return lua_yield(L, 1);
    }
    else if (argc == 1)
    {
        if (lua_isstring(L, 1))
        {
            text = lua_tostring(L, 1);
        }
        else
        {
            return luaL_error(L, "Say(): argument must be a string");
        }
    }
    else if (argc == 2)
    {
        if (lua_isstring(L, 1) && lua_isstring(L, 2))
        {
            speaker = lua_tostring(L, 1);
            text = lua_tostring(L, 2);
        }
        else if (lua_isstring(L, 1) && lua_isnumber(L, 2))
        {
            text = lua_tostring(L, 1);
            duration = (float)lua_tonumber(L, 2);
        }
        else
        {
            return luaL_error(L, "Say(): invalid arguments");
        }
    }
    else
    {
        speaker = luaL_checkstring(L, 1);
        text = luaL_checkstring(L, 2);
        if (lua_isnumber(L, 3))
            duration = (float)lua_tonumber(L, 3);
    }

    // Build table
    lua_newtable(L);
    lua_pushstring(L, "SAY"); lua_setfield(L, -2, "type");

    if (speaker && *speaker) { lua_pushstring(L, speaker); lua_setfield(L, -2, "speaker"); }
    if (text && *text) { lua_pushstring(L, text);    lua_setfield(L, -2, "text"); }

    if (duration >= 0.0f)
    {
        lua_pushnumber(L, duration);
        lua_setfield(L, -2, "duration");
    }

    return lua_yield(L, 1);
}

int Lua_SetEmotion(lua_State* L)
{
    std::string emotionId = luaL_optstring(L, 1, "TDisabled");

    if (emotionId.empty())
        emotionId = "TDisabled";

    LuaManager::Get().SetEmotion(emotionId);

    return 0;
}



int Lua_SetThunder(lua_State* L)
{
    int n = lua_gettop(L);

    // If no argument -> enable
    if (n == 0)
    {
        Graphics::Get().GetThunder().Enable(true);
    }
    else
    {
        bool on = lua_toboolean(L, 1);
        Graphics::Get().GetThunder().Enable(on);
    }

    return 0;
}

int Lua_TriggerThunder(lua_State* L)
{
    int n = lua_gettop(L);

    int count = (n >= 1 && lua_isnumber(L, 1)) ? (int)lua_tointeger(L, 1) : 1;
    int minAlpha = (n >= 2 && lua_isnumber(L, 2)) ? (int)lua_tointeger(L, 2) : 100;
    int maxAlpha = (n >= 3 && lua_isnumber(L, 3)) ? (int)lua_tointeger(L, 3) : 180;

    Graphics::Get().GetThunder().Trigger(count, minAlpha, maxAlpha);
    return 0;
}

int Lua_SetNoise(lua_State* L)
{
    int n = lua_gettop(L);

    bool on = true; // default enable

    // First argument: optional boolean
    if (n >= 1 && !lua_isnil(L, 1))
        on = lua_toboolean(L, 1);

    // Apply enable/disable
    Graphics::Get().GetNoiser().Enable(on);

    // Second argument: optional alpha override
    if (n >= 2 && lua_isnumber(L, 2))
    {
        float alpha = (float)lua_tonumber(L, 2);
        Graphics::Get().GetNoiser().SetAlpha(alpha);
    }

    return 0;
}

int Lua_SetInventory(lua_State* L)
{
    bool enabled = lua_toboolean(L, 1);

    Inventory* inventory = ((Inventory*)Game::Get().Scenes.GetInventory());

    inventory->SetEnabled(enabled);

    return 0;
}

int Lua_ShowInventory(lua_State* L)
{
    float delay = (float)luaL_checknumber(L, 1);
    
    Inventory* inventory = ((Inventory*)Game::Get().Scenes.GetInventory());

    inventory->ForceVisible(delay);

    return 0;
}

int Lua_ToastMessage(lua_State* L)
{
    // Toast(text, x, y [, duration, size, r, g, b, a])
    const char* text = luaL_checkstring(L, 1);
    float x = (float)luaL_optnumber(L, 2, 0.0);
    float y = (float)luaL_optnumber(L, 3, 0.0);
    float duration = (float)luaL_optnumber(L, 4, 3.0);
    float size = (float)luaL_optnumber(L, 5, 24.0);

    int   r = (int)luaL_optnumber(L, 6, 255);
    int   g = (int)luaL_optnumber(L, 7, 255);
    int   b = (int)luaL_optnumber(L, 8, 255);
    int   a = (int)luaL_optnumber(L, 9, 255);

    Color color = { (unsigned char)r, (unsigned char)g,
                   (unsigned char)b, (unsigned char)a };

    Graphics::Get().ToastMessage(text, { x, y }, duration, size, color);
    return 0;
}

int Lua_SplashTitle(lua_State* L)
{
    // Lua: Title(text [, duration, size, x, y, r, g, b, a])
    const char* text = luaL_optstring(L, 1, nullptr);
    if (!text) return 0; // ignore if no title provided

    float duration = (float)luaL_optnumber(L, 2, 3.0);
    float size = (float)luaL_optnumber(L, 3, 64.0);
    float x = (float)luaL_optnumber(L, 4, 0.0);
    float y = (float)luaL_optnumber(L, 5, 0.0);

    int r = (int)luaL_optnumber(L, 6, 255);
    int g = (int)luaL_optnumber(L, 7, 255);
    int b = (int)luaL_optnumber(L, 8, 255);
    int a = (int)luaL_optnumber(L, 9, 255);

    Color color = { (unsigned char)r, (unsigned char)g,
                    (unsigned char)b, (unsigned char)a };

    Graphics::Get().SplashTitle(text, duration, size, { x, y }, color);
    return 0;
}

int Lua_GiveItem(lua_State* L) 
{
    const std::string& item = luaL_checkstring(L, 1);

    lua_newtable(L);                       // create table
    lua_pushstring(L, "CMD");              // type = "CMD"
    lua_setfield(L, -2, "type");

    lua_pushstring(L, "GiveItem");         // command = "GiveItem"
    lua_setfield(L, -2, "command");

    lua_pushstring(L, item.c_str());               // value = "Sword"
    lua_setfield(L, -2, "value");

    return lua_yield(L, 1);                // yield table
}

int Lua_SetState(lua_State* L) 
{
    // Expecting 2 string arguments: (entityName, textureID)
    const std::string& nameID = luaL_checkstring(L, 1);
    const std::string& textureID = luaL_checkstring(L, 2);

    // Call your C++ implementation
    Director::Get().SetEntityTexture( nameID, textureID);

    return 0; // No return values
}

int Lua_SetActive(lua_State* L) 
{
    int argc = lua_gettop(L);
    const std::string& nameID = luaL_checkstring(L, 1);
    bool active = true; // default

    if (argc >= 2)
        active = lua_toboolean(L, 2);

    Director::Get().SetEntityActive(nameID, active);

    return 0;
}

int Lua_GetActive(lua_State* L)
{
    // Expect 1 string argument
    const std::string& nameID = luaL_checkstring(L, 1);

    bool active = false;

    if (Entity* entity = Director::Get().GetEntity(nameID))
        active = entity->GetIsActive();
    else
        std::cout << "[Lua_GetActive] Entity not found: " << nameID << std::endl;

    lua_pushboolean(L, active); // return the bool value
    return 1; // number of return values
}

int Lua_SetAlpha(lua_State* L)
{
    int argc = lua_gettop(L);
    const std::string& nameID = luaL_checkstring(L, 1);
    float alpha = 1.0f; // default

    if (argc >= 2)
        alpha = (float)luaL_checknumber(L, 2);

    Director::Get().SetEntityAlpha(nameID, alpha);

    return 0;
}

int Lua_GetAlpha(lua_State* L)
{
    // Expect 1 string argument
    const std::string& nameID = luaL_checkstring(L, 1);

    float alpha = 0.0f;

    if (Entity* entity = Director::Get().GetEntity(nameID))
        alpha = entity->GetAlpha();
    else
        std::cout << "[Lua_GetAlpha] Entity not found: " << nameID << std::endl;

    lua_pushnumber(L, alpha); // return the float value
    return 1; // number of return values
}

int Lua_SetVisible(lua_State* L)  
{
    const std::string nameID = luaL_checkstring(L, 1);
    bool visible = true; // default to visible

    if (lua_gettop(L) >= 2 && lua_isboolean(L, 2))
            visible = lua_toboolean(L, 2);
        else
        {
#ifdef _DEBUG
            std::cout << "[Lua_SetVisible] Warning: second arg not boolean, forcing visible = true\n";
#endif // DEBUG
            visible = true;
        }

    Director::Get().SetEntityVisible(nameID, visible);
    return 0;
}


int Lua_GetVisible(lua_State* L)
{
    // Expect 1 string argument
    const std::string& nameID = luaL_checkstring(L, 1);

    bool visible = false;

    if (Entity* entity = Director::Get().GetEntity(nameID))
        visible = entity->GetIsVisible();
    else
        std::cout << "[Lua_GetVisible] Entity not found: " << nameID << std::endl;

    lua_pushboolean(L, visible); // return the bool value
    return 1; // number of return values
}

int Lua_SetClickable(lua_State* L)
{
    int argc = lua_gettop(L);
    const std::string& nameID = luaL_checkstring(L, 1);
    bool visible = true; // default

    if (argc >= 2)
        visible = lua_toboolean(L, 2);

    Director::Get().SetEntityClickable(nameID, visible);

    return 0;
}

int Lua_GetClickable(lua_State* L)
{
    // Expect 1 string argument
    const std::string& nameID = luaL_checkstring(L, 1);

    bool clickable = false;

    if (Entity* entity = Director::Get().GetEntity(nameID))
        clickable = entity->GetIsClickable();
    else
        std::cout << "[Lua_GetClickable] Entity not found: " << nameID << std::endl;

    lua_pushboolean(L, clickable); // return the bool value
    return 1; // number of return values
}

int Lua_SetPosition(lua_State* L)
{
    // Expecting: (string entityID, number x, number y)
    const std::string& nameID = luaL_checkstring(L, 1);

    if (Entity* entity = Director::Get().GetEntity(nameID))
    {
        float x = (float)luaL_checknumber(L, 2);
        float y = (lua_gettop(L) >= 3) ?
            (float)luaL_checknumber(L, 3) :
            entity->GetPositionY(); // or similar

        Director::Get().SetEntityPosition(nameID, x, y);
    }

    return 0;
}

int Lua_SetShadeAlpha(lua_State* L)
{
    int argc = lua_gettop(L);
    float alpha = (float)luaL_checknumber(L, 1);

    LuaManager::Get().SetShadeAlpha(alpha);

    return 0;
}


int Lua_SetEntityScene(lua_State* L) 
{
    // Expecting: (string entityID, string sceneID)
    const std::string& nameID = luaL_checkstring(L, 1);
    const std::string& sceneID = luaL_checkstring(L, 2);

    Game::Get().Scenes.ChangeEntityScene(nameID, sceneID);

    return 0;
}

int Lua_IsEntityInScene(lua_State* L)
{
    // Expecting:
    const char* nameID = luaL_checkstring(L, 1);        // 1: entity nameID (string)
    const char* sceneID = luaL_checkstring(L, 2);       // 2: sceneID (string)

    bool result = Game::Get().Scenes.IsEntityInScene(nameID, sceneID);

    // Push result back to Lua
    lua_pushboolean(L, result);
    return 1; // one return value
}

int Lua_SetEntityFront(lua_State* L)
{
    int argc = lua_gettop(L);
    if (argc < 1) return 0;

    const char* id = luaL_checkstring(L, 1);
    int offset = (argc >= 2 && lua_isnumber(L, 2)) ? (int)lua_tointeger(L, 2) : 0;

    Game::Get().Scenes.ChangeEntityToFront(id, offset);

    return 0;
}

int Lua_SetEntityBack(lua_State* L)
{
    int argc = lua_gettop(L);
    if (argc < 1) return 0;

    const char* id = luaL_checkstring(L, 1);
    int offset = (argc >= 2 && lua_isnumber(L, 2)) ? (int)lua_tointeger(L, 2) : 0;

    Game::Get().Scenes.ChangeEntityToBack(id, offset);

    return 0;
}

int Lua_RemoveEntity(lua_State* L)
{
    const char* entityId = luaL_checkstring(L, 1);

    Game::Get().Scenes.RemoveEntity(entityId);

    return 0; // no return values
}

int Lua_DisableEntity(lua_State* L)
{
    const char* entityId = luaL_checkstring(L, 1);

    Game::Get().Scenes.DisableEntity(entityId);

    return 0; // no return values
}

int Lua_SetCurrentScene(lua_State* L)
{
    // Expecting: (string sceneID)
    const std::string& sceneID = luaL_checkstring(L, 1);

	Graphics::Get().GetWiper().Start(WIPE_DOWN);

    Game::Get().Scenes.ChangeCurrent(sceneID);

    return 0;
}

int Lua_SwipeScene(lua_State* L)
{
    // Expecting: (string sceneID)
    const std::string& sceneID = luaL_checkstring(L, 1);
    const std::string& swipeType = luaL_optstring(L, 2, "Up");

    Game::Get().Scenes.Render();										/// <--------------------

    if (swipeType == "Up")
        Graphics::Get().GetWiper().Start(WIPE_UP);
    else if (swipeType == "Left")
        Graphics::Get().GetWiper().Start(WIPE_LEFT);
    else if (swipeType == "Right")
        Graphics::Get().GetWiper().Start(WIPE_RIGHT);
    else
        Graphics::Get().GetWiper().Start(WIPE_DOWN);

    Game::Get().Scenes.ChangeCurrent(sceneID);

    return 0;
}

int Lua_BlendScene(lua_State* L)
{
    // Expecting: (string sceneID)
    const std::string& sceneID = luaL_checkstring(L, 1);
    float duration = (float)luaL_optnumber(L, 2, 2.0f);

    Game::Get().Scenes.Render();										/// <--------------------

    Graphics::Get().GetBlender().Start(duration);

    Game::Get().Scenes.ChangeCurrent(sceneID);

    return 0;
}

int Lua_InitializeScene(lua_State* L)
{
    // Expecting: (string sceneID)
    const std::string& sceneID = luaL_checkstring(L, 1);
    Game::Get().Scenes.Initialize(sceneID);

    return 0;
}

int Lua_DeinitializeScene(lua_State* L)
{
    const std::string& sceneID = luaL_checkstring(L, 1);
    Game::Get().Scenes.Deinitialize(sceneID);

    return 0;
}

int Lua_LoadTexture(lua_State* L)
{
    // Expecting 2 string arguments: (entityName, textureID)
    const std::string& textureID = luaL_checkstring(L, 1);
    const std::string& texturePath = luaL_checkstring(L, 2);

    // Call your C++ implementation
    Assets::Get().LoadTextureID(textureID, texturePath);

    return 0; // No return values
}

int Lua_MoveEntity(lua_State* L) 
{
    // Expecting 2~4 arguments: (entityName, targetX, targetY, timeLapse)
    const std::string& nameID = luaL_checkstring(L, 1);
    
    float currentY = 0.f;
    if (Entity* entity = Director::Get().GetEntity(nameID))
        currentY = (float)entity->GetPositionY();

    float x = (float)luaL_checknumber(L, 2);
    float y = (float)luaL_optnumber(L, 3, currentY);
    float lapse = (float)luaL_optnumber(L, 4, 3.0f);

    Director::Get().MoveEntity(nameID, x, y, lapse);
    return 0;
}

int Lua_FadeEntity(lua_State* L)
{
    // Expecting 2~3 arguments: (entityName, targetValue, timeLapse)
    const std::string& nameID = luaL_checkstring(L, 1);
    float targetAlpha = (float)luaL_checknumber(L, 2);
    float currentAlpha = (targetAlpha == 0.f ? 1.0f : 0.f);

    if (Entity* entity = Director::Get().GetEntity(nameID))
        currentAlpha = entity->GetAlpha();

    float lapse = (float)luaL_optnumber(L, 3, 3.0f);

    Director::Get().FadeEntity(nameID, currentAlpha, targetAlpha, lapse);

    return 0; // No return values
}

int Lua_ScaleEntity(lua_State* L)
{
    // Expecting 2~3 arguments: (entityName, endScale, timeLapse)
    const std::string& nameID = luaL_checkstring(L, 1);
    float factor = (float)luaL_optnumber(L, 2, 1.0f);
    float lapse = (float)luaL_optnumber(L, 3, 3.0f);

    Director::Get().ScaleEntity(nameID, factor, lapse);
    return 0;
}

int Lua_ShakeEntity(lua_State* L)
{
    // Expecting 2~3 arguments: (entityName, targetValue, timeLapse)
    const std::string& nameID = luaL_checkstring(L, 1);
    float amount = (float)luaL_checknumber(L, 2);
    float totalTime = (float)luaL_optnumber(L, 3, 3.0f);

    Director::Get().ShakeEntity(nameID, amount, totalTime);

    return 0; // No return values
}

int Lua_StopTween(lua_State* L)
{
    // Expecting 1 argument: (entityName)
    const std::string& nameID = luaL_checkstring(L, 1);
    Director::Get().StopEntity(nameID);

    return 0; // No return values
}


// AUDIO BINDINGS
int Lua_PlaySound(lua_State* L)
{
    const char* soundArg = luaL_checkstring(L, 1);
    std::string soundIDOrPath = soundArg;

    if (Assets::Get().HasSoundID(soundIDOrPath))
    {
        Sound sound = Assets::Get().GetSound(soundIDOrPath);
        if (IsSoundValid(sound))
            PlaySound(sound);
    }
    else
    {
        Audio::Get().PlaySound(soundIDOrPath);
    }

    return 0;
}

int Lua_PreloadSound(lua_State* L)
{
    const char* soundArg = luaL_checkstring(L, 1);
    std::string soundIDOrPath = soundArg;

    if (!Assets::Get().HasSoundID(soundIDOrPath))
        Audio::Get().PreloadSound(soundIDOrPath);

    return 0;
}

int Lua_PlayMusic(lua_State* L)
{
    const char* musicArg = luaL_checkstring(L, 1);
    std::string musicIDOrPath = musicArg;

    bool isLooping = lua_isnoneornil(L, 2) ? true : (lua_toboolean(L, 2) != 0);

    if (Assets::Get().HasMusicID(musicIDOrPath))
    {
        const Music& music = Assets::Get().GetMusic(musicIDOrPath);
        Audio::Get().PlayMusic(music, isLooping);
    }
    else
    {
        Audio::Get().PlayMusic(musicIDOrPath, isLooping);
    }

    return 0;
}

int Lua_StopMusic(lua_State* L)
{
    Audio::Get().StopMusic();
    return 0;
}

int Lua_FadeMusic(lua_State* L)
{
    bool fadeIn = lua_isnoneornil(L, 1) ? true : (lua_toboolean(L, 1) != 0);

    if (fadeIn)
        Audio::Get().FadeMusicIn();
    else
        Audio::Get().FadeMusicOut();

    return 0;
}

int Lua_ToggleMusic(lua_State* L)
{
    Audio::Get().ToggleMusic();
    return 0;
}

int Lua_IsPlayingMusic(lua_State* L)
{
    lua_pushboolean(L, Audio::Get().IsPlayingMusic());
    return 1;
}

int Lua_SetMusicVolume(lua_State* L)
{
    float volume = (float)luaL_checknumber(L, 1);
    Audio::Get().SetMusicVol(volume);
    return 0;
}

/*

*/



// Lua: Schedule(delay, luaFuncName, [repeatFlag], [id])
// Schedule(5, "Fade", "Dark", 0.0, 5.0)
int Lua_Schedule(lua_State* L)
{
    float delay = static_cast<float>(luaL_checknumber(L, 1));
    const char* funcName = luaL_checkstring(L, 2);

    int argc = lua_gettop(L) - 2;

    // capture args + type info
    std::vector<int> argTypes;
    std::vector<std::string> argStr;
    std::vector<double> argNum;

    argTypes.reserve(argc);
    argStr.reserve(argc);
    argNum.reserve(argc);

    int top = lua_gettop(L);
    for (int i = 3; i <= top; ++i)
    {
        if (lua_isstring(L, i))
        {
            argTypes.push_back(1);
            argStr.push_back(lua_tostring(L, i));
            argNum.push_back(0);
        }
        else if (lua_isnumber(L, i))
        {
            argTypes.push_back(2);
            argStr.push_back("");
            argNum.push_back(lua_tonumber(L, i));
        }
        else if (lua_isboolean(L, i))
        {
            argTypes.push_back(3);
            argStr.push_back("");
            argNum.push_back(lua_toboolean(L, i) ? 1.0 : 0.0);
        }
        else
        {
            luaL_error(L, "Schedule only supports string/number/boolean args");
        }
    }

    Director::Get().Schedule(delay,
        [func = std::string(funcName), argc, argTypes, argStr, argNum]()
        {
            lua_State* Ls = LuaManager::Get().GetState();
            lua_getglobal(Ls, func.c_str());

            int si = 0, ni = 0;
            for (int i = 0; i < argc; i++)
            {
                if (argTypes[i] == 1) lua_pushstring(Ls, argStr[si++].c_str());
                else if (argTypes[i] == 2) lua_pushnumber(Ls, argNum[ni++]);
                else if (argTypes[i] == 3) lua_pushboolean(Ls, argNum[ni++] != 0.0);
            }

            if (lua_pcall(Ls, argc, 0, 0) != LUA_OK)
            {
                std::cerr << "[Schedule Error] "
                    << lua_tostring(Ls, -1) << "\n";
                lua_pop(Ls, 1);
            }
        });

    return 0;
}



//ScheduleRepeat(1, "PulseLight", "Light1", 0.5, "PulseLoop")
int Lua_ScheduleRepeat(lua_State* L)
{
    float delay = (float)luaL_checknumber(L, 1);
    const char* funcName = luaL_checkstring(L, 2);

    int top = lua_gettop(L);

    // The last argument is the ID for cancellation
    std::string id = luaL_checkstring(L, top);

    int argc = top - 3;

    std::vector<int> argTypes;
    std::vector<std::string> argStr;
    std::vector<double> argNum;

    argTypes.reserve(argc);
    argStr.reserve(argc);
    argNum.reserve(argc);

    // Gather arguments except last (which is id)
    for (int i = 3; i < top; ++i)  // stop before last slot (the ID)
    {
        if (lua_isstring(L, i))
        {
            argTypes.push_back(1);
            argStr.push_back(lua_tostring(L, i));
            argNum.push_back(0);
        }
        else if (lua_isnumber(L, i))
        {
            argTypes.push_back(2);
            argStr.push_back("");
            argNum.push_back(lua_tonumber(L, i));
        }
        else if (lua_isboolean(L, i))
        {
            argTypes.push_back(3);
            argStr.push_back("");
            argNum.push_back(lua_toboolean(L, i) ? 1.0 : 0.0);
        }
        else
        {
            luaL_error(L, "Schedule only supports string/number/boolean args");
        }
    }

    // Schedule the repeat task
    Director::Get().Schedule(
        delay,
        [func = std::string(funcName), argc, argTypes, argStr, argNum]()
        {
            lua_State* Ls = LuaManager::Get().GetState();
            lua_getglobal(Ls, func.c_str());

            int si = 0, ni = 0;
            for (int i = 0; i < argc; i++)
            {
                if (argTypes[i] == 1) lua_pushstring(Ls, argStr[si++].c_str());
                else if (argTypes[i] == 2) lua_pushnumber(Ls, argNum[ni++]);
                else if (argTypes[i] == 3) lua_pushboolean(Ls, argNum[ni++] != 0.0);
            }

            if (lua_pcall(Ls, argc, 0, 0) != LUA_OK)
            {
                std::cerr << "[ScheduleRepeat Error] "
                    << lua_tostring(Ls, -1) << "\n";
                lua_pop(Ls, 1);
            }
        },
        true,   // repeat
        id      // user-supplied ID
    );

    // Return ID to Lua
    lua_pushstring(L, id.c_str());
    return 1;
}



// Lua: ScheduleDirector(delay, funcName, [args...])
//   ScheduleDirector(3.0, "FadeEntity", "John", "0.0", "1.0", "2.0")
int Lua_ScheduleDirector(lua_State* L)
{
    float delay = static_cast<float>(luaL_checknumber(L, 1));
    const char* funcName = luaL_checkstring(L, 2);

    int top = lua_gettop(L);
    std::vector<std::string> args;

    for (int i = 3; i <= top; ++i)
    {
        if (lua_isstring(L, i))
            args.emplace_back(lua_tostring(L, i));
        else
            args.emplace_back("");
    }

    Director::Get().Schedule(delay, [func = std::string(funcName), args]() {
        Director::Get().CallFunction(func, args);
        });

    return 0;
}

//   ScheduleDirector(5.0, "MoveEntity", "Door", "100", "150", "4.0", true, "MoveDoorLoop") [id]
int Lua_ScheduleDirectorRepeat(lua_State* L)
{
    float delay = (float)luaL_checknumber(L, 1);
    const char* funcName = luaL_checkstring(L, 2);

    int top = lua_gettop(L);

    // The last argument must be the ID
    std::string id = luaL_checkstring(L, top);

    // Collect args (except last which is id)
    std::vector<std::string> args;
    for (int i = 3; i < top; ++i)
        args.emplace_back(lua_tostring(L, i));

    // Schedule and return ID
    Director::Get().Schedule(delay, [func = std::string(funcName), args]() {
        Director::Get().CallFunction(func, args);
        }, true, id);

    lua_pushstring(L, id.c_str());
    return 1;
}


int Lua_CancelScheduled(lua_State* L)
{
    const char* id = luaL_checkstring(L, 1);
    Director::Get().CancelScheduledTask(id);
    return 0;
}


void RegisterLuaFunctions() // C++ Foo Register in Lua
{
    LuaManager::Get().RegisterFunction("traceback", traceback);

    LuaManager::Get().RegisterFunction("StartSequence", Lua_StartSequence);

    LuaManager::Get().RegisterFunction("SetEmotion", Lua_SetEmotion);

    LuaManager::Get().RegisterFunction("EndSequence", Lua_EndSequence);

    LuaManager::Get().RegisterFunction("Schedule", Lua_Schedule);

    LuaManager::Get().RegisterFunction("ScheduleRepeat", Lua_ScheduleRepeat);

    LuaManager::Get().RegisterFunction("ScheduleDirector", Lua_ScheduleDirector);
    
    LuaManager::Get().RegisterFunction("ScheduleDirectorRepeat", Lua_ScheduleDirectorRepeat);
    
    LuaManager::Get().RegisterFunction("CancelScheduled", Lua_CancelScheduled);

    LuaManager::Get().RegisterFunction("SetInventory", Lua_SetInventory);           // SetInventory( enabled = true)

    LuaManager::Get().RegisterFunction("ShowInventory", Lua_ShowInventory);           // SetInventory( enabled = true)

    LuaManager::Get().RegisterFunction("SetThunder", Lua_SetThunder);               // SetThunder( enabled = true)

    LuaManager::Get().RegisterFunction("TriggerThunder", Lua_TriggerThunder);       // TriggerThunder( count = 1)

    LuaManager::Get().RegisterFunction("SetNoise", Lua_SetNoise);       // SetNoise(true, 0.7) or  SetNoise(0.7) enables and set alpha value

    LuaManager::Get().RegisterFunction("Toast", Lua_ToastMessage);

    LuaManager::Get().RegisterFunction("ShowTitle", Lua_SplashTitle);

    LuaManager::Get().RegisterFunction("GiveItem", Lua_GiveItem);

    LuaManager::Get().RegisterFunction("SetState", Lua_SetState);

    LuaManager::Get().RegisterFunction("SetActive", Lua_SetActive);

    LuaManager::Get().RegisterFunction("GetActive", Lua_GetActive);

    LuaManager::Get().RegisterFunction("SetVisible", Lua_SetVisible);

    LuaManager::Get().RegisterFunction("GetVisible", Lua_GetVisible);

    LuaManager::Get().RegisterFunction("SetAlpha", Lua_SetAlpha);

    LuaManager::Get().RegisterFunction("GetAlpha", Lua_GetAlpha);

    LuaManager::Get().RegisterFunction("SetClickable", Lua_SetClickable);

    LuaManager::Get().RegisterFunction("GetClickable", Lua_GetClickable);

    LuaManager::Get().RegisterFunction("SetPosition", Lua_SetPosition);

    LuaManager::Get().RegisterFunction("SetShadeAlpha", Lua_SetShadeAlpha);

    LuaManager::Get().RegisterFunction("Fade", Lua_FadeEntity);

    LuaManager::Get().RegisterFunction("Move", Lua_MoveEntity);

    LuaManager::Get().RegisterFunction("Scale", Lua_ScaleEntity);

    LuaManager::Get().RegisterFunction("Shake", Lua_ShakeEntity);

    LuaManager::Get().RegisterFunction("StopTween", Lua_StopTween);

    LuaManager::Get().RegisterFunction("SetEntityScene", Lua_SetEntityScene);

    LuaManager::Get().RegisterFunction("IsEntityInScene", Lua_IsEntityInScene);

    LuaManager::Get().RegisterFunction("SetEntityFront", Lua_SetEntityFront);

    LuaManager::Get().RegisterFunction("SetEntityBack", Lua_SetEntityBack);

    LuaManager::Get().RegisterFunction("DisableEntity", Lua_DisableEntity);

    LuaManager::Get().RegisterFunction("RemoveEntity", Lua_RemoveEntity);

    LuaManager::Get().RegisterFunction("SetCurrentScene", Lua_SetCurrentScene);

    LuaManager::Get().RegisterFunction("SwipeScene", Lua_SwipeScene);

    LuaManager::Get().RegisterFunction("BlendScene", Lua_BlendScene);

    LuaManager::Get().RegisterFunction("Initialize", Lua_InitializeScene);

    LuaManager::Get().RegisterFunction("Deinitialize", Lua_DeinitializeScene);

    LuaManager::Get().RegisterFunction("LoadTexture", Lua_LoadTexture);

    // AUDIO BINDINGS

    LuaManager::Get().RegisterFunction("PreloadSound", Lua_PreloadSound);
    LuaManager::Get().RegisterFunction("PlaySound", Lua_PlaySound);
    LuaManager::Get().RegisterFunction("PlayMusic", Lua_PlayMusic);
    LuaManager::Get().RegisterFunction("StopMusic", Lua_StopMusic);
    LuaManager::Get().RegisterFunction("FadeMusic", Lua_FadeMusic);
    LuaManager::Get().RegisterFunction("ToggleMusic", Lua_ToggleMusic);
    LuaManager::Get().RegisterFunction("IsPlayingMusic", Lua_IsPlayingMusic);
    LuaManager::Get().RegisterFunction("SetMusicVolume", Lua_SetMusicVolume);

}


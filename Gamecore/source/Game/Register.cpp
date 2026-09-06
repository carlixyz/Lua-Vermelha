#include "Register.h"
#include "../Utility/Utils.h"
#include "raylib.h"

bool Register::Init()
{
    Threads = {
        { "Intro",          "Boot"              },
        { "MadWorld",       "GuestRoom"         },
        { "WoodMorning",    "WoodMorningIntro"  },
        { "Maneater",       "ReginaRoom"        },
        { "CrimeWave",      "Jail"              },
        { "GhostsAgain",    "Dreamscape"        },
        { "BrainJar",       "BlindingLights"    },
        { "BlindingLight",  "BrainJarVision"    }
    };

    return true;
}

bool  Register::Deinit()
{
    Clear();
    Threads.clear();

    return true;
}

bool Register::CheckNegation(const std::string& key)
{
    std::string keyStr = key;
    size_t negationPos = keyStr.find('!');
    bool isNegation = (negationPos != std::string::npos && negationPos == 0);
 
    return isNegation;
}

bool Register::GetFlag(const std::string& key)
{
    CHECK(!CheckNegation(key)); // NO '!' Expressions allowed!

    auto result = Flags.find(key);
    return result != Flags.end() && result->second;
}

void Register::SetFlag(const std::string& key, bool value)
{
    CHECK(!CheckNegation(key)); // NO '!' Expressions allowed!

    Flags[key] = value;
}

void Register::Clear(const std::string& Name)
{
    Flags.erase(Name);
}

void Register::Clear()
{
    Flags.clear();

    for (auto& Thread : Threads)
    {
        Thread.Started = false;
        Thread.Completed = false;
    }
}

void Register::StartThread(const std::string& Name)
{
    for (auto& Thread : Threads)
    {
        if (Thread.Name != Name)
            continue;

        CurrentThread = Name;
        Thread.Started = true;
        return;
    }
}

bool Register::IsThreadStarted(const std::string& Name) const
{
    for (const auto& Thread : Threads)
        if (Thread.Name == Name)
            return Thread.Started;

    return false;
}

bool Register::IsThreadCompleted(const std::string& Name) const
{
    for (const auto& Thread : Threads)
        if (Thread.Name == Name)
            return Thread.Completed;

    return false;
}

int Register::GetCompletedThreadCount() const
{
    int Count = 0;

    for (const auto& Thread : Threads)
        if (Thread.Completed)
            ++Count;

    return Count;
}

const std::string Register::GetRandomNewThread() const
{
    std::vector<std::string> Available;

    for (const auto& Thread : Threads)      // Ensure other threads where played be4 BrainJar
        if (!Thread.Started && (GetCompletedThreadCount() < 6 && Thread.Name != "BrainJar") ) 
            Available.push_back(Thread.Name);

    if (Available.empty())
        return {};

    return Available[GetRandomValue(0, (int)Available.size() - 1)];
}

void Register::ForceThreadCompleted(const std::string& ThreadID)
{
    if (ThreadID.empty())
    {
        SetCurrentThreadCompleted();
        return;
    }

    for (auto& Thread : Threads)
    {
        if (Thread.Name != ThreadID)
            continue;

        Thread.Started = true;
        Thread.Completed = true;
        return;
    }
}

void Register::SetCurrentThreadCompleted()
{
    for (auto& Thread : Threads)
    {
        if (Thread.Name != CurrentThread)
            continue;

        Thread.Completed = true;
        CurrentThread.clear();
        return;
    }
}

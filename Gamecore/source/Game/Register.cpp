#include "Register.h"
#include "../Utility/Utils.h"
#include "raylib.h"

void Register::Init()
{
    Threads = {
        { "Intro" },
        { "MadWorld" },
        { "WoodMorning" } ///,
        //{ "Maneater" },
        //{ "CrimeWave" },
        //{ "GhostsAgain" },
        //{ "BrainJar" },
        //{ "BlindingLights" }
    };
}

void Register::Deinit()
{
    Clear();
    Threads.clear();
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

    for (const auto& Thread : Threads)
        if (!Thread.Started)
            Available.push_back(Thread.Name);

    if (Available.empty())
        return {};

    return Available[GetRandomValue(0, (int)Available.size() - 1)];
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

const std::string& Register::GetCurrentThread() const
{
    return CurrentThread;
}
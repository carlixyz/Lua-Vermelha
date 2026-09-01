#pragma once

#include "../Utility/Singleton.h"
#include <iostream>
#include <unordered_map>
#include <vector>

struct StoryThread
{
	std::string Name;
	bool Started = false;
	bool Completed = false;
};

class Register : public Singleton<Register>
{
public:

	void Init();
	void Deinit();

	// you can check a simple expression like "!var_is_enabled"
	bool GetFlag(const std::string& key);
	void SetFlag(const std::string& key, bool value);

	void Clear(const std::string& Name);
	void Clear();

	void StartThread(const std::string& Name);
	const std::string GetRandomNewThread() const;

	void SetCurrentThreadCompleted();
	const std::string& GetCurrentThread() const;
	
	bool IsThreadStarted(const std::string& Name) const;
	bool IsThreadCompleted(const std::string& Name) const;

	int GetCompletedThreadCount() const;
	//void ForceThread(const std::string& Name, bool completed);

	const std::unordered_map<std::string, bool>& GetFlags() const { return Flags; }
	const std::vector<StoryThread>& GetThreads() const { return Threads; }

private:
	friend class Singleton<Register>;

	std::string CurrentThread;
	std::unordered_map<std::string, bool> Flags;
	std::vector<StoryThread> Threads;

	bool CheckNegation(const std::string& key);
};


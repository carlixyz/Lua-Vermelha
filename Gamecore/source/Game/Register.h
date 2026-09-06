#pragma once

#include "../Utility/Singleton.h"
#include <iostream>
#include <unordered_map>
#include <vector>

struct StoryThread
{
	std::string Name;
	std::string Scene;
	bool Started = false;
	bool Completed = false;
};

class Register : public Singleton<Register>
{
public:

	bool Init();
	bool Deinit();

	// you can check a simple expression like "!var_is_enabled"
	bool GetFlag(const std::string& key);
	void SetFlag(const std::string& key, bool value);

	void Clear(const std::string& Name);
	void Clear();

	void StartThread(const std::string& Name);
	const std::string GetRandomNewThread() const;

	void ForceThreadCompleted(const std::string& ThreadID = "");
	void SetCurrentThreadCompleted();

	inline const std::string& GetCurrentThread() const { return CurrentThread; }
	
	bool IsThreadStarted(const std::string& Name) const;
	bool IsThreadCompleted(const std::string& Name) const;
	int GetCompletedThreadCount() const;

	const std::unordered_map<std::string, bool>& GetFlags() const { return Flags; }
	const std::vector<StoryThread>& GetThreads() const { return Threads; }

private:
	friend class Singleton<Register>;

	std::string CurrentThread;
	std::unordered_map<std::string, bool> Flags;
	std::vector<StoryThread> Threads;

	bool CheckNegation(const std::string& key);
};


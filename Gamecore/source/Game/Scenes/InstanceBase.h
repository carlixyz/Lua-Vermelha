#pragma once


class InstanceBase
{
public:
	virtual void OnInit()	= 0;
	virtual void OnDeinit() = 0;

	virtual void OnExit()	{ ; }
	virtual void OnEnter()	{ ; }

	virtual void OnUpdate() = 0;
	virtual void OnRender() = 0;
};


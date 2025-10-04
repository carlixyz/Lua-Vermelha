-- =========================================
-- Dialog utilities
-- =========================================

-- Call SAY (still immediate yield from C++)
-- But use inside action tables like { Say, "Hello" }
-- Or directly: Say("Hello")
-- (C++ already registered this)
-- function Say(line, ...) -- from C++

-- Call GiveItem (C++ already registered)
-- function GiveItem(item) -- from C++

Globals = {}


-- Assign to globals safely (Don't rewrite this function!')
function Set(varName, value)
    _G[varName] = value
end

function Say(line)          
    coroutine.yield({ type = "SAY", text = line })
end

--[[
function Say(line)
    if _inBlock then
        return function() coroutine.yield({ type="SAY", text=line }) end
    else
        coroutine.yield({ type="SAY", text=line })
    end
end
]]--

-- Core executor
local function run_action(a)
    if type(a) == "function" then
        a()

    elseif type(a) == "string" then
        -- Sugar: treat plain string as dialog line
        Say(a)

    elseif type(a) == "table" then
        if a[1] and type(a[1]) == "function" then
            -- Call descriptor: { fn, arg1, arg2, ... }
            local fn = a[1]
            fn(table.unpack(a, 2))
        else
            -- Nested action list: { action1, action2, ... }
            for _, sub in ipairs(a) do
                run_action(sub)
            end
        end
    end
end


-- Branching dialog choice
function Choice(...)
    local options = { ... }
    local visible = {}

    for _, opt in ipairs(options) do
        local cond, text, actions
        if type(opt[1]) == "boolean" then
            cond, text = opt[1], opt[2]
            actions = { select(3, table.unpack(opt)) }
        else
            cond, text = true, opt[1]
            actions = { select(2, table.unpack(opt)) }
        end
        if cond then
            table.insert(visible, { text = text, actions = actions })
        end
    end

    -- Yield menu to C++
    local labels = {}
    for _, v in ipairs(visible) do
        table.insert(labels, v.text)
    end
    local choice = coroutine.yield({ type = "CHOICE", options = labels })

    -- Run chosen branch
    local branch = visible[choice]
    if branch then
        for _, action in ipairs(branch.actions) do
            run_action(action)
        end
    end
end

function Globals.OnInit(args)
    if args then
        print("Default OnInit -> " .. tostring(args))
        return { NameId = args }
    else
        print("Default OnInit -> (no args)")
    end
end


function Globals.OnDeinit()
    print("Default DeInit ")
end


function Globals.OnUpdate()
    print("Default OnUpdate ")
end


function Globals.OnRender()
    print("Default OnRender ")
end


function Globals.OnEnter()
    print("Default OnEnter ")
end


function Globals.OnExit()
    print("Default OnExit ")
end


function Globals.OnInteract()
    print("Nothing to do here")
end


function Globals.OnTalk()
    print("Nothing to talk")
end


function Globals.OnUse()
    print("Nothing to do")
end


function Globals.OnLook()
    print("There's nothing interesting")
end


function Globals.OnCombine(args)
    if args and type(args) == "string" then
        print("Can't mix up those " .. tostring(args))
    else
        print("Can't mix up those.. (invalid)")
    end
end


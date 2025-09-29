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


-- Assign to globals safely
function Set(varName, value)
    _G[varName] = value
end


function Say(line)
    coroutine.yield({ type = "SAY", text = line })
end

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


local function OnConstruct()
    
    print("called elder.OnConstruct")

    return {
        NameId = "Elder",
        Visible = true,
        Position = { x = 300, y = 150 },
        Alpha = 0.5
    }
end

local function OnInit()
    
    print("called elder.OnInit")

end

local function OnDeinit()
    print("called elder.OnDeinit")

end

local function OnInteract()
    print("called elder.OnInteract")

end

return {
    OnConstruct = OnConstruct,
    OnInit = OnInit,
    OnDeinit = OnDeinit,
    OnInteract = OnInteract
}
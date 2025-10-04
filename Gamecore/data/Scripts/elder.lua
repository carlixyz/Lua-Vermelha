


local function OnInit()
    
    print("called elder.OnInit")

    return {
        NameId = "Elder",
        Visible = true,
        Position = { x = 300, y = 150 },
        Alpha = 0.5
    }
end

local function OnDeinit()
    print("called elder.OnDeinit")

end

local function OnInteract()
    print("called elder.OnInteract")

end

return {
    OnInit = OnInit,
    OnDeinit = OnDeinit,
    OnInteract = OnInteract
}

    Elder = {}
    Elder.enabled = false

local function OnConstruct()
    
    print("called elder.OnConstruct")
    
    return {
        NameId = "Elder",
        Visible = true,
        Position = { x = 250, y = 150 },
        Textures = {
            { Mirror = "data/Scenes/Intro/RearMirror.png" }
        },
        CurrentImage = "Mirror"
    }
end

local function OnInit()
    
        print("called elder.OnInit")
end

local function OnDeinit()
    print("called elder.OnDeinit")

end

local function OnInteract()
    if Elder.enabled == true then
        print("called elder.OnInteract")
    else
        print("ENABLE ELDER PLEASE")
    end

end

return {
    OnConstruct = OnConstruct,
    OnInit = OnInit,
    OnDeinit = OnDeinit,
    OnInteract = OnInteract
}
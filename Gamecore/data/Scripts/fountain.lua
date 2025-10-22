
--return { }

--local function OnInit()
--    print("called Fountain.OnInit")
--end

local function OnConstruct()
    
    --print("called Fountain.OnConstruct")

    return {
        NameId = "Fountain",
        Visible = true,
        Clickable = true,
        Position = { x = 0, y = 0 },
        Alpha = 1.0,
        Textures = {
            { MansionDay = "data/Scenes/Mansion_Day.jpg" },
            { MansionNight = "data/Scenes/Mansion_Night.jpg" }
        },
        CurrentImage = "MansionNight"
    }
end


local function OnInteract()
    --print("called Fountain.OnInteract")
    SwipeScene("Test2", "Left")
    --BlendScene("Test2", 2)


    -- SetState("Fountain", "MansionNight")
end

local function OnLook()
    --print("called Fountain.OnLook")
    SetState("Fountain", "MansionDay")
end


return {
    OnConstruct = OnConstruct,
    -- OnInit = OnInit,
    OnLook = OnLook,
    OnInteract = OnInteract
}
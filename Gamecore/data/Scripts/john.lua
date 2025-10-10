


local function OnInit()
    
    print("called John.OnInit")

    return {
        NameId = "John",
        Visible = true,
        Position = { x = 20, y = 200 },
        Alpha = 1.0,
        Textures = {
            { J_Neutral = "data/Images/John/John_neutral.png" },
            { J_Happy = "data/Images/John/John_smile.png" },
            { J_Wow = "data/Images/John/John_surprise.png" }
        },
        CurrentImage = "J_Happy"
    }
end

local function OnDeinit()
    print("called John.OnDeinit")

end

local function OnTalk()
    print("called John.OnTalk")
    SetPosition("John", 300, 200)
end

local function OnInteract()
    print("called John.OnInteract")
    OnTalk()
end

local function OnLook()
    print("called John.OnLook")
    SetState("John", "J_Wow")
end


return {
    OnInit = OnInit,
    OnDeinit = OnDeinit,
    OnLook = OnLook,
    OnInteract = OnInteract
}
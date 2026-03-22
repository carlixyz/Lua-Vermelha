
local function OnConstruct()
    
    print("called Image.OnConstruct")

    return {
        NameId = "Image",
        Visible = true,
        Position = { x = 20, y = 200 },
        Alpha = 1.0,
        Textures = {
            { I_Neutral = "data/Images/John/John_neutral.png" },
            { I_Happy = "data/Images/John/John_smile.png" },
            { I_Wow = "data/Images/John/John_surprise.png" }
        },
        CurrentImage = "I_Happy"
    }
end


local function OnTalk()
    print("called Image.OnTalk")
end


local function OnInteract()
    print("called Image.OnInteract")
end


local function OnLook()
    print("called Image.OnLook")
end


return {
    OnConstruct = OnConstruct,
    OnDeinit = OnDeinit,
    OnLook = OnLook,
    OnInteract = OnInteract
}
local function OnConstruct()
    
    print("called John.OnConstruct")

    return {
        NameId = "John",
        Visible = true,
--        Clickable = false,
        Position = { x = 40, y = 200 },
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

    SwipeScene("Test", "Down")
    --BlendScene("Test")

    -- SetState("John", "J_Neutral")
    -- SetPosition("John", 300, 200)
end

local function OnInteract()
    print("called John.OnInteract")
    Fade('John', 1.0)
    -- SetScene( 'John', 'Test' )
    --Fade("John", 1.0, 3)
    --Move("John", 20)
    -- SetVisible("John", false)
    --SetActive("John", false)
    --SetClickable("John", false)

    --Elder.enabled = true
    
    --OnTalk()
end

local function OnLook()
    print("called John.OnLook")
    -- SetState("John", "J_Wow")
    Fade("John", 0.0, 6)
    --Move("John", 60, 100, 6)
    -- SetVisible("John", true)
    --SetActive("John", true)
    --SetClickable("John", true)
end

local function OnCombine(itemId)
    print("called John.OnCombine with itemId:", itemId)
    
    if (itemId == "Med") then
        print("MED Object detect!")
        Say("This is a medication for me? thank you!")
    end
end


return {
    OnConstruct = OnConstruct,
    OnDeinit = OnDeinit,
    OnLook = OnLook,
    OnCombine = OnCombine,
    OnInteract = OnInteract
}
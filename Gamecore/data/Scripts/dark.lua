Dark = Dark or {}
Dark.Alpha = 1.0

local function OnConstruct()
    
    print("called Dark.OnConstruct")

    return {
        NameId = "Dark",
        Visible = false,
        Active = false,
        Clickable = false,
        Alpha = Dark.Alpha,
        Textures = {
            { Dark = "data/Images/Dark.png" }
        },
        CurrentImage = "Dark"
    }
end

return {
    OnConstruct = OnConstruct
}
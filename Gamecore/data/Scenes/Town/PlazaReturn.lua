return {
    { Entity = "PlazaReturn", Textures = {
        {ReturnDay = "data/Scenes/Town/PlazaReturnDay.jpg"}, 
        {ReturnDusk = "data/Scenes/Town/PlazaReturnSunset.jpg"}, 
        {ReturnSunset = "data/Scenes/Town/PlazaReturnNight.jpg"}, 
        {ReturnNight = "data/Scenes/Town/PlazaReturnLua.jpg" }}
    },

    
    { Quad = { OnConstruct = function() return { NameId = "GoToHospitalCorner", Cursor = "MLeft", Pos = { x = 0, y = 70 },
        Size = { Width = 165, Height = 300 }} end, OnInteract = function() SwipeScene("PlazaFountain", "Right") end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "TurnToBarCorner", Cursor = "MDown", Pos = { x = 0, y = 370 }, 
        Size = { Width = 920, Height = 140 }} end, OnInteract = function() SwipeScene("BarOutside", "Up") end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "ReturnToTownView", Cursor = "MUp", Pos = { x = 750, y = 70 },
        Size = { Width = 165, Height = 300 }} end, OnInteract = function() SwipeScene("PlazaPan", "Down") 
        if PlazaPan.State == 1 then PlazaPan.GoLeft() end end } -- Simple check to ensure facing the right side of PlazaPan
    }
}
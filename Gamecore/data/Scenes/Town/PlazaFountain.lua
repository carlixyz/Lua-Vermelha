return {
    { Entity = "Fountain", Textures = {
        {FountainDay = "data/Scenes/Town/PlazaFountainDay.jpg"}, 
        {FountainSunset = "data/Scenes/Town/PlazaFountainSunset.jpg"}, 
        {FountainNight = "data/Scenes/Town/PlazaFountainNight.jpg"}, 
        {FountainLua = "data/Scenes/Town/PlazaFountainLua.jpg" }} 
    },


    { Quad = { OnConstruct = function() return { NameId = "GoToTunnelExit", Cursor = "MUp", Pos = { x = 0, y = 70 },
        Size = { Width = 165, Height = 300 }} end, OnInteract = function() SwipeScene("PlazaExit", "Down") end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "TurnToHospital", Cursor = "MDown", Pos = { x = 0, y = 370 }, 
        Size = { Width = 920, Height = 140 }} end, OnInteract = function() SwipeScene("HospitalOutside", "Up") end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "ReturnToBarCornerBack", Cursor = "MRight", Pos = { x = 750, y = 70 },
        Size = { Width = 165, Height = 300 }} end, OnInteract = function() SwipeScene("PlazaReturn", "Left") end } 
    }
}
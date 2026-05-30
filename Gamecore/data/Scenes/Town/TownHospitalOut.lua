return {
    { Entity = "HospitalOutBG", Textures = {
        {HospitalDay = "data/Scenes/Town/HospitalOutDay.jpg"}, 
        {HospitalNight = "data/Scenes/Town/HospitalOutNight.jpg"}, 
        {HospitalLua = "data/Scenes/Town/HospitalOutLua.jpg" }, 
        {Medic = "data/Scenes/Town/Medic.jpg" }} 
    },

    { Quad = { OnConstruct = function() return { NameId = "EnterHospital", Cursor = "MUp", Pos = { x = 330, y = 203 }, 
        Size = { Width = 365, Height = 143 }} end, OnInteract = function() SwipeScene("HospitalInside", "Down") end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "TurnToPlazaFountain", Cursor = "MDown", Pos = { x = 0, y = 370 }, 
        Size = { Width = 920, Height = 140 }} end, OnInteract = function() SwipeScene("PlazaFountain", "Up") end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "PanToBar", Cursor = "MLeft", Pos = { x = 0, y = 70 },
        Size = { Width = 165, Height = 300 }} end, OnInteract = function() SwipeScene("BarOutside", "Right") end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "PanToTunnel", Cursor = "MRight", Pos = { x = 750, y = 70 },
        Size = { Width = 165, Height = 300 }} end, OnInteract = function() SwipeScene("PlazaFountain", "Left") end }
    }

}
return {
    { Entity = "Bar", Textures = {
        {BarOutDay = "data/Scenes/Town/BarOutDay.jpg"},
        {BarOutNight = "data/Scenes/Town/BarOutNight.jpg"},
        {BarOutLua = "data/Scenes/Town/BarOutLua.jpg" },
        {BarInDay = "data/Scenes/Town/BarInDay.jpg" },
        {BarInNight = "data/Scenes/Town/BarInNight.jpg" },
        {Drunk = "data/Scenes/Town/Drunk.jpg" }}
    },

    { Quad = { OnConstruct = function() return { NameId = "EnterBar", Cursor = "MUp", Pos = { x = 103, y = 124 }, 
        Size = { Width = 239, Height = 162 }} end, OnInteract = function() SwipeScene("BarInside", "Down") end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "TurnToPlazaReturn", Cursor = "MDown", Pos = { x = 0, y = 370 }, 
        Size = { Width = 920, Height = 140 }} end, OnInteract = function() SwipeScene("PlazaReturn", "Up") end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "PanToPlaza", Cursor = "MLeft", Pos = { x = 0, y = 70 },
        Size = { Width = 165, Height = 300 }} end, OnInteract = function() SwipeScene("PlazaPan", "Right") 
        if PlazaPan.State == 1 then PlazaPan.GoLeft() end end  } 
    },

    { Quad = { OnConstruct = function() return { NameId = "PanToHospital", Cursor = "MRight", Pos = { x = 750, y = 70 },
        Size = { Width = 165, Height = 300 }} end, OnInteract = function() SwipeScene("HospitalOutside", "Left") end }
    }
}
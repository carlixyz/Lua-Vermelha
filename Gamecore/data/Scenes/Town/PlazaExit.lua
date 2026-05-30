return {
    { Entity = "PlazaExit", Textures = {
        {PlazaExitDay = "data/Scenes/Town/PlazaExitDay.jpg"}, 
        {PlazaExitDusk = "data/Scenes/Town/PlazaExitSunset.jpg"}, 
        {PlazaExitSunset = "data/Scenes/Town/PlazaExitNight.jpg"}, 
        {PlazaExitNight = "data/Scenes/Town/PlazaExitLua.jpg" }} 
    },


    { Quad = { OnConstruct = function() return { NameId = "Tunnel entry", Cursor = "MUp", Pos = { x = 5, y = 170 }, 
        Size = { Width = 120, Height = 145 }} end, OnInteract = function() SwipeScene("Tunnel", "Down") end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "ToTheHospital", Cursor = "MDown", Pos = { x = 0, y = 400 }, 
        Size = { Width = 600, Height = 115 }} end, OnInteract = function() SwipeScene("PlazaFountain", "Up") end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "Luperta Statue", Position = { x = 700, y = 160 },
        Size = { Width = 100, Height = 120 }} end, OnInteract = function() SwipeScene("Luperta", "Left") end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "PlazaEntryShortcut", Cursor = "MRight", Position = { x = 850, y = 160 },
        Size = { Width = 100, Height = 120 }} end, OnInteract = function() SwipeScene("PlazaPan", "Left") 
        if PlazaPan.State == 0 then PlazaPan.GoRight() end
        end } 
    }

}
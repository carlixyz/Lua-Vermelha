return {
    { Entity = "PlazaExit", Textures = {
        {PlazaExitDay = "data/Scenes/Town/PlazaExitDay.jpg"}, 
        {PlazaExitDusk = "data/Scenes/Town/PlazaExitSunset.jpg"}, 
        {PlazaExitSunset = "data/Scenes/Town/PlazaExitNight.jpg"}, 
        {PlazaExitNight = "data/Scenes/Town/PlazaExitLua.jpg" }} 
    },

    { Quad = { OnConstruct = function() return { NameId = "Tunnel entry", Position = { x = 600, y = 100 },
        Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("Luperta", "Down") end } 
    }
}
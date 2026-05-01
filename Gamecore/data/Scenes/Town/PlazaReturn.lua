return {
    { Entity = "PlazaReturn", Textures = {
        {ReturnDay = "data/Scenes/Town/PlazaReturnDay.jpg"}, 
        {ReturnDusk = "data/Scenes/Town/PlazaReturnSunset.jpg"}, 
        {ReturnSunset = "data/Scenes/Town/PlazaReturnNight.jpg"}, 
        {ReturnNight = "data/Scenes/Town/PlazaReturnLua.jpg" }}
    },

    { Quad = { OnConstruct = function() return { NameId = "Fountain path", Position = { x = 600, y = 100 },
        Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("PlazaFountain", "Down") end } 
    }
}
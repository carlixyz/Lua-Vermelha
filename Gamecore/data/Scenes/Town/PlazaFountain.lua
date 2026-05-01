return {
    { Entity = "Fountain", Textures = {
        {FountainDay = "data/Scenes/Town/PlazaFountainDay.jpg"}, 
        {FountainDusk = "data/Scenes/Town/PlazaFountainSunset.jpg"}, 
        {FountainSunset = "data/Scenes/Town/PlazaFountainNight.jpg"}, 
        {FountainNight = "data/Scenes/Town/PlazaFountainLua.jpg" }} 
    },

    { Quad = { OnConstruct = function() return { NameId = "Path Hospital", Position = { x = 600, y = 100 },
        Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("Hospital", "Down") end } 
    }
}
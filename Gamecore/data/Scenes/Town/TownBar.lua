return {
    { Entity = "Bar", Textures = {
        {BarOutDay = "data/Scenes/Town/BarOutDay.jpg"},
        {BarOutNight = "data/Scenes/Town/BarOutNight.jpg"},
        {BarOutLua = "data/Scenes/Town/BarOutLua.jpg" },
        {BarInDay = "data/Scenes/Town/BarInDay.jpg" },
        {BarInNight = "data/Scenes/Town/BarInNight.jpg" },
        {Drunk = "data/Scenes/Town/Drunk.jpg" }}
    },

    { Quad = { OnConstruct = function() return { NameId = "Path entry", Position = { x = 600, y = 100 },
        Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("PlazaPan", "Down") end } 
    }
}
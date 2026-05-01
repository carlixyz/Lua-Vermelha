return {
    { Entity = "Cemetery", Textures = {
        {CemeteryOut = "data/Scenes/Parking/Sanctuary.jpg" },
        {CemeteryEntry = "data/Scenes/Parking/CemeteryGate.jpg"}, 
        {Cemetery = "data/Scenes/Parking/Cemetery.jpg"}}
    },

    { Quad = { OnConstruct = function() return { NameId = "Cemetery Gate", Position = { x = 600, y = 100 },
        Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("PlazaPan", "Down") end } 
    }
}
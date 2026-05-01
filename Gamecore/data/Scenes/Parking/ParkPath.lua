return {
    { Entity = "Town Branch", Textures = {
        {TownPathDeep = "data/Scenes/Parking/TownPathDeep.jpg"}, 
        {TownPathA = "data/Scenes/Parking/TownPathA.jpg"}, 
        {TownPathB = "data/Scenes/Parking/TownPathB.jpg"}, 
        {TownView = "data/Scenes/Parking/TownView.jpg"}}
    },

    { Quad = { OnConstruct = function() return { NameId = "Woods Path", Position = { x = 600, y = 100 },
        Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("Cemetery", "Down") end } 
    }
}
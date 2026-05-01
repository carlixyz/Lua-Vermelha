return {
    { Entity = "ParkSide", Position = { x = 0, y = 0 }, Textures = "data/Scenes/Parking/FachadeSide.jpg", Visible = false, Alpha = 0.0  },
    { Entity = "ParkTop", Position = { x = 0, y = 0 }, Textures = "data/Scenes/Parking/ParkTop.jpg", Visible = false, Alpha = 0.0  },

    { Quad = { OnConstruct = function() return { NameId = "Park exit", Position = { x = 600, y = 100 },
        Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("ParkPath", "Down") end } 
    }
}
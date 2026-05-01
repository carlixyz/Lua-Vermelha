return {
    { Entity = "Park", Textures = {
        {ParkFrontDay = "data/Scenes/Parking/MansionDay.jpg"}, 
        {ParkFrontCloudy = "data/Scenes/Parking/MansionCloudy.jpg"}, 
        {ParkFrontSunset = "data/Scenes/Parking/MansionSunset.jpg"}, 
        {ParkFrontNight = "data/Scenes/Parking/MansionNight.jpg"}, 
        {ParkFrontLua = "data/Scenes/Parking/MansionLua.jpg"}}
    },

    { Entity = "ParkSide", Position = { x = 0, y = 0 }, Textures = "data/Scenes/Parking/FachadeSide.jpg", Visible = false, Alpha = 0.0  },
    { Entity = "ParkTop", Position = { x = 0, y = 0 }, Textures = "data/Scenes/Parking/ParkTop.jpg", Visible = false, Alpha = 0.0  },

    { Quad = { OnConstruct = function() return { NameId = "Park exit", Position = { x = 600, y = 100 },
        Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("ParkPath", "Down") end } 
    }
}
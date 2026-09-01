return {
    { Entity = "MansionFrontBG", Textures = {
        {MansionFrontDay = "data/Scenes/Parking/MansionDay.jpg"},
        {MansionFrontCloudy = "data/Scenes/Parking/MansionCloudy.jpg"},
        {MansionFrontSunset = "data/Scenes/Parking/MansionSunset.jpg"},
        {MansionFrontNight = "data/Scenes/Parking/MansionNight.jpg"},
        {MansionFrontLua = "data/Scenes/Parking/MansionLua.jpg"}
    }},

    { Entity = "MansionParkTop", Textures = "data/Scenes/Parking/ParkTop.jpg", Visible = false, Alpha = 0.0  },

    { Quad = { OnConstruct = function() 
        Schedule( 1.0, "SetInventory", true) SetThunder(false) SetNoise(false)
        return { NameId = "Mansion Sideview", Cursor = "MDown",
        Pos = { x = 0, y = 400 }, Size = { Width = 920, Height = 110 }} end, 
        OnInteract = function() SwipeScene("MansionSide", "Up") end} 
    },

    { Quad = { OnConstruct = function() return { NameId = "Mansion Entry", Cursor = "MUp",
        Pos = { x = 600, y = 100 }, Size = { Width = 200, Height = 280 }} end, 
        OnInteract = function() PlaySound("DoorOpen") SwipeScene("Lobby", "Down") FadeMusic(1) end } 
    }
}
return {
        { Entity = "CarTrunkBG", Textures = {
            {TrunkOpen = "data/Scenes/Parking/TrunkOpen.jpg"}, 
            {TrunkOpenB = "data/Scenes/Parking/TrunkOpenB.jpg"}, 
            {TrunkOpenC = "data/Scenes/Parking/TrunkOpenC.jpg"},
            {TrunkOpenNight = "data/Scenes/Parking/TrunkOpenNight.jpg"}}
    },

    { Quad = { OnConstruct = function() return { NameId = "TrunkLeft", NameView = "Left\nSide", Cursor = "MLeft", 
        Clickable = true, Pos = { x = 0, y = 80 }, Size = { Width = 60, Height = 436 }} end, 
        OnInteract = function() SwipeScene("TownPath", "Right") PlaySound("SwipeOut") end } 
    }, -- LEFT SIDE

    { Quad = { OnConstruct = function() return { NameId = "TrunkDown", NameView = "Rollback", Cursor = "MDown", 
        Clickable = true, Pos = { x = 60, y = 400 }, Size = { Width = 860, Height = 115 }} end, 
        OnInteract = function() SwipeScene("TownPath", "Up") PlaySound("SwipeOut") end } 
    } -- BOTTOM SIDE

}
return {
    { Entity = "MansionSideBG", Textures = {
        {FachadeSide = "data/Scenes/Parking/FachadeSide.jpg"}, 
        {FachadeSideBike = "data/Scenes/Parking/FachadeBike.jpg"}}
    },

    { Entity = "MansionSideTop", Position = { x = 0, y = 0 }, Textures = "data/Scenes/Parking/ParkTop.jpg", Visible = false, Alpha = 0.0  },

    { Quad = { OnConstruct = function() return { NameId = "Road Path",  Cursor = "MUp", Position = { x = 600, y = 100 },
        Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("RoadPath", "Down") end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "Town Path & Car", Cursor = "MUp", Position = { x = 300, y = 100 },
        Size = { Width = 280, Height = 280 }} end, OnInteract = function() SwipeScene("TownPath", "Down") end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "Mansion\nFront",  Cursor = "MLeft", Pos = { x = 0, y = 80 }, 
        Size = { Width = 200, Height = 516 }} end, OnInteract = function() SwipeScene("MansionFront", "Right") end } 
    }

}
return {
    { Entity = "LupertaStatue", Textures = {
        {LupertaDayClosed = "data/Scenes/Town/LupertaDayClosed.jpg"},
        {LupertaDayOpen = "data/Scenes/Town/LupertaDayOpen.jpg"},
        {LupertaSunOff = "data/Scenes/Town/LupertaSunsetOff.jpg"},
        {LupertaSunOn = "data/Scenes/Town/LupertaSunsetOn.jpg" },
        {LupertaCloseUp = "data/Scenes/Town/LupertaSunsetCloseUp.jpg" }} 
    },

    { Quad = { OnConstruct = function() return { NameId = "Plaza Return", Position = { x = 600, y = 100 },
        Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("PlazaReturn", "Down") end } 
    }
}
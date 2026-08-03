return {
    { Entity = "LupertaStatueBG", Textures = {
        {LupertaDayClosed = "data/Scenes/Town/LupertaDayClosed.jpg"},
        {LupertaDayOpen = "data/Scenes/Town/LupertaDayOpen.jpg"},
        {LupertaNight = "data/Scenes/Town/LupertaNightClosed.jpg"},
        {LupertaSunOff = "data/Scenes/Town/LupertaSunsetOff.jpg"},
        {LupertaSunOn = "data/Scenes/Town/LupertaSunsetOn.jpg" },
        {LupertaCloseUp = "data/Scenes/Town/LupertaSunsetCloseUp.jpg" }} 
    },

    { Quad = { OnConstruct = function() return { NameId = "Plaza Return", Cursor = "MRight", Position = { x = 700, y = 100 },
        Size = { Width = 220, Height = 280 }} end, OnInteract = function() SwipeScene("PlazaPan", "Left") 
        if PlazaPan.State == 0 then PlazaPan.GoRight() end
        end } 
    }
}
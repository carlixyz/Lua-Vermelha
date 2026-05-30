return {
    { Entity = "Tunnel",  Textures = {
        {TunnelDay = "data/Scenes/Town/TunnelDay.jpg"},
        {TunnelNight = "data/Scenes/Town/TunnelNight.jpg"},
        {TunnelLua = "data/Scenes/Town/TunnelLua.jpg" },
        {TunnelSunset = "data/Scenes/Town/TunnelSunset.jpg" }}
    },

    { Quad = { OnConstruct = function() return { NameId = "ReturnToPlazaBack", Cursor = "MDown", Pos = { x = 0, y = 370 }, 
        Size = { Width = 920, Height = 140 }} end, OnInteract = function() SwipeScene("PlazaExit", "Up") end } 
    }
}
return {
    { Entity = "Lobby", Position = { x = 0, y = 0 }, Textures = {
            {LobbyDay = "data/Scenes/Mansion/LobbyDay.jpg"}, 
            {LobbySunset = "data/Scenes/Mansion/LobbySunset.jpg"}, 
            {LobbyDusk = "data/Scenes/Mansion/LobbyDusk.jpg"}, 
            {LobbyNight = "data/Scenes/Mansion/LobbyNight.jpg" }} 
    },

    { Quad = { OnConstruct = function() return { NameId = "Lobby exit", Position = { x = 600, y = 100 },
            Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("Park", "Down") end } 
    }
}
return {
    { Entity = "MapBoardBG", Textures = {
        {MapBDay = "data/Scenes/Town/MapBoardDay.jpg"},
        {MapBSunset = "data/Scenes/Town/MapBoardSunset.jpg"},
        {MapBNight = "data/Scenes/Town/MapBoardNight.jpg" }} 
    },

    { Quad = { OnConstruct = function() return { NameId = "MapBoard",
       Pos = { x = 250, y = 90 }, Size = { Width = 265, Height = 270 }} end, 
       OnInteract = function() StartSequence( function() Say("Mhh it's the valley's map", 3.0) Say() end) end, 
       OnLook = function() StartSequence( function() Say("This might be helpful for guidence", 3.0) Say() end) end}     
    },

    { Quad = { OnConstruct = function() return { NameId = "Ad poster",
       Pos = { x = 686, y = 86 }, Size = { Width = 140, Height = 220 }} end, 
       OnInteract = function() StartSequence( function() Say("Nothing to do with that", 3.0) Say() end) end, 
       OnLook = function() StartSequence( function() Say("It's an ad about the Lua Vermelha carnival or something", 3.0) Say() end) end}     
    },

    { Quad = { OnConstruct = function() return { NameId = "ReturnToPlazaTunnelEntry", Cursor = "MDown",
        Pos = { x = 0, y = 370 }, Size = { Width = 920, Height = 140 }} end, 
        OnInteract = function() SwipeScene("PlazaExit", "Up") end } 
    }
}
return {
    { Entity = "DepotBG", Visible = true, Textures = {
        {DepotGate = "data/Scenes/Mansion/DepotDayGate.jpg"},
        {DepotDay = "data/Scenes/Mansion/DepotDay.jpg"},
        {DepotDuskClosed = "data/Scenes/Mansion/DepotDuskBlind.jpg"},
        {DepotDuskBlind = "data/Scenes/Mansion/DepotDuskClosed.jpg"},
        {DepotDuskNoLamp = "data/Scenes/Mansion/DepotDuskNoLamp.png"},
        {DepotDuskOpen = "data/Scenes/Mansion/DepotDuskOpen.jpg"},
        {DepotDuskOpenNoLadder = "data/Scenes/Mansion/DepotDuskOpenNoLadder.jpg"},
        {DepotLua = "data/Scenes/Mansion/DepotLua.jpg"},
        {DepotNight = "data/Scenes/Mansion/DepotNight.jpg"},
        {DepotSunset = "data/Scenes/Mansion/DepotSunset.jpg"} }
    },


    { Quad = { OnConstruct = function() return { NameId = "Pool View",
        Pos = { x = 0, y = 0 }, Size = { Width = 222, Height = 459 }} end, 
       OnInteract = function() StartSequence( function() Say("The gate is closed.", 3.0) Say() end) end, 
       OnLook = function() StartSequence( function() Say("There's a Pool in the far", 3.0) Say() end) end}     
    },

    { Quad = { OnConstruct = function() return { NameId = "Depot door",
        Pos = { x = 404, y = 4 }, Size = { Width = 322, Height = 506 }} end, 
        OnInteract = function() StartSequence( function() Say("The door is closed.", 3.0) Say() end) end, 
        OnLook = function() StartSequence( function() Say("I think there's a depot behind", 3.0) Say() end) end} 
    },

    { Quad = { OnConstruct = function() return { NameId = "PoolReturnTOHallway", Cursor = "MRight",
        Pos = { x = 820, y = 0 }, Size = { Width = 100, Height = 512 }} end, 
        OnInteract = function() SwipeScene("HallwayInit", "Left") end } 
    }

}
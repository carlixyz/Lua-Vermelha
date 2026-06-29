return {
    { Entity = "CorralBG", Visible = true, Textures = {
        {CorralDay = "data/Scenes/Mansion/CorralExitDay.jpg"},
        {CorralCloud = "data/Scenes/Mansion/CorralExitCloud.jpg"},
        {CorralDusk = "data/Scenes/Mansion/CorralExitDusk.jpg"},
        {CorralNight = "data/Scenes/Mansion/CorralExitLight.jpg"} }
    },


    { Quad = { OnConstruct = function() return { NameId = "CorralExitDoor", Cursor = "MUp",
       Pos = { x = 456, y = 107 }, Size = { Width = 102, Height = 236 }} end, 
       OnInteract = function() StartSequence( function() Say("The gate is closed.", 3.0) Say() end) end, 
       OnLook = function() StartSequence( function() Say("There're horses in the far", 3.0) Say() end) end}     
    },

    { Quad = { OnConstruct = function() return { NameId = "cabinet door",
        Pos = { x = 565, y = 150 }, Size = { Width = 123, Height = 208 }} end, 
        OnInteract = function() StartSequence( function() Say("The door is closed.", 3.0) Say() end) end, 
        OnLook = function() StartSequence( function() Say("Seems like cabinet to hold farm things inside", 3.0) Say() end) end} 
    },

    { Quad = { OnConstruct = function() return { NameId = "CorralReturnTOHallway", Cursor = "MDown",
        Pos = { x = 0, y = 400 }, Size = { Width = 920, Height = 110 }} end, 
        OnInteract = function() SwipeScene("HallwayInit", "Up") end } 
    }

}
return {
    { Entity = "JailBG", Visible = true, Textures = "data/Scenes/Town/JailBase.jpg" },

    { Entity = "JailIntro", Visible = true, Textures = "data/Scenes/Town/JailApperture.jpg" },

    { Quad = { OnConstruct = function() return { NameId = "JailVent",
        Pos = { x = 0, y = 0 }, Size = { Width = 222, Height = 459 }} end, 
       OnInteract = function() StartSequence( function() Say("The gate is closed.", 3.0) Say() end) end, 
       OnLook = function() StartSequence( function() Say("There's a Pool in the far", 3.0) Say() end) end}     
    },

    { Quad = { OnConstruct = function() return { NameId = "JailTile",
        Pos = { x = 404, y = 4 }, Size = { Width = 322, Height = 506 }} end, 
        OnInteract = function() StartSequence( function() Say("The door is closed.", 3.0) Say() end) end, 
        OnLook = function() StartSequence( function() Say("I think there's a depot behind", 3.0) Say() end) end} 
    },

    { Quad = { OnConstruct = function() return { NameId = "JailMate", 
        Pos = { x = 820, y = 0 }, Size = { Width = 100, Height = 512 }} end, 
        OnInteract = function() SwipeScene("HallwayInit", "Left") end } 
    }

}
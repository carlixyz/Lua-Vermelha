return {
    { Entity = "ViktorDoorBG", Visible = true, Textures = { 
        {ViktorDoorKnob = "data/Scenes/Mansion/DoorKnob.jpg"} }
    },

    { Quad = { OnConstruct = function() return { NameId = "ViktorDoorExit", NameView = "Knob hole",
       Pos = { x = 352, y = 22 }, Size = { Width = 270, Height = 230 }} end, 
       OnInteract = function() StartSequence( function() Say("I can't open this door", 3.0) Say() end) end, 
       OnLook = function() StartSequence( function() Say("The door doesn't have a knob", 3.0) Say() end) end}     
    },

    { Quad = { OnConstruct = function() return { NameId = "ViktorDoorReturnToHallway", Cursor = "MDown",
        Pos = { x = 0, y = 400 }, Size = { Width = 920, Height = 110 }} end, 
        OnInteract = function() SwipeScene("HallwayInit", "Up") end } 
    }

}
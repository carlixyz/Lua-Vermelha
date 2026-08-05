return {
        { Entity = "CarBG", Textures = {
            {WheelFlat = "data/Scenes/Parking/WheelFlat.jpg"}, 
            {WheelFlatTrunk = "data/Scenes/Parking/WheelFlatBack.jpg"}, 
            {WheelBase = "data/Scenes/Parking/WheelBase.jpg"},
            {WheelTrunk = "data/Scenes/Parking/WheelBack.jpg"},
            {WheelJack = "data/Scenes/Parking/WheelJack.jpg"},
            {WheelRemoved = "data/Scenes/Parking/WheelRemoved.jpg"},
            {WheelReplaced = "data/Scenes/Parking/WheelReplaced.jpg"}}
    },

    { Quad = (function() 
        local self = {}
        function self.OnConstruct() return { NameId = "WheelAxis", 
        Pos = { x = 273, y = 252 }, Size = { Width = 207, Height = 215 }} end
        function self.OnCommentEntry() Say("Damn, I have a flat tire.", 3.0) Say() end
        function self.OnCommentLook() Say("I'll need to fix it later.", 5.0) Say() end
        function self.OnInteract() StartSequence(self.OnCommentEntry) end function self.OnLook() StartSequence(self.OnCommentLook) end 
        return self
        end)()
    },

    { Quad = { OnConstruct = function() return { NameId = "RollbackLeft", NameView = "Left\nSide", Cursor = "MLeft",
        Clickable = true, Pos = { x = 0, y = 80 }, Size = { Width = 60, Height = 436 }} end, 
        OnInteract = function() SwipeScene("TownPath", "Right") PlaySound("SwipeOut") end } 
    }, -- LEFT SIDE

    { Quad = { OnConstruct = function() return { NameId = "RollbackRight", NameView = "Right\nSide", Cursor = "MRight",
        Clickable = true, Pos = { x = 840, y = 0 }, Size = { Width = 80, Height = 516 }} end, 
        OnInteract = function() SwipeScene("TownPath", "Left") PlaySound("SwipeIn") end } 
    } -- RIGHT SIDE

}
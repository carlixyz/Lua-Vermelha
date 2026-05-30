return {
    { Entity = "RoadBG", Textures = {
        {Sanctuary = "data/Scenes/Parking/Sanctuary.jpg"}, 
        {SanctuaryLua = "data/Scenes/Parking/SanctuaryLua.jpg"}, 
        {SanctuaryBike = "data/Scenes/Parking/SanctuaryBike.jpg"}}
    },

    { Quad = (function()
        local self = {}
        function self.OnConstruct() return { NameId = "Sanctuary", --Cursor = "MUp",
        Pos = { x = 32, y = 100 }, Size = { Width = 325, Height = 210 }} end
        function self.OnCommentEntry() Say("This is an interaction", 3.0) Say() end
        function self.OnCommentLook() Say("This is an observation", 3.0) Say() end
        function self.OnInteract() SwipeScene("Cemetery", "Right") end 
        function self.OnLook() StartSequence(self.OnCommentLook) end 
        return self
        end)()
    },

    { Quad = (function()
        local self = {}
        function self.OnConstruct() return { NameId = "MansionFrontFar", NameView = "Mansion Front", Cursor = "MUp",
        Pos = { x = 510, y = 135 }, Size = { Width = 140, Height = 90 }} end
        function self.OnInteract() SwipeScene("MansionSide", "Down") end 
        function self.OnCommentLook() Say("This is an observation", 3.0) Say() end
        function self.OnLook() StartSequence(self.OnCommentLook) end 
        return self
        end)()
    },

    { Quad = (function() 
        local self = {}
        function self.OnConstruct() return { NameId = "CarFar", NameView = "Car front", Cursor = "MUp",
            Pos = { x = 655, y = 132 }, Size = { Width = 163, Height = 133 }} end
        function self.OnCommentLook() Say("This is an observation", 3.0) Say() end
        function self.OnInteract() SwipeScene("Car", "Down") end 
        function self.OnLook() StartSequence(self.OnCommentLook) end 
        return self
        end)()
    }

}
return {
    { Entity = "TownViewBG", Textures = "data/Scenes/Parking/TownView.jpg" },

    { Quad = (function()
        local self = {}
        function self.OnConstruct() return { NameId = "Town View", Scale = 1.5,
            Pos = { x = 196, y = 55 }, Size = { Width = 364, Height = 188 }} end
        function self.OnCommentEntry() Say("Such a nice view,\n There's a river between the town and here", 6.0) Say() end
        function self.OnCommentLook() Say("This town is pretty small,\njust six squares and a center plaza", 63.0) Say() end
        function self.OnInteract() StartSequence(self.OnCommentEntry) end function self.OnLook() StartSequence(self.OnCommentLook) end 
        return self
        end)()
    },

    { Quad = { OnConstruct = function() return { NameId = "Wooden Sign", Pos = { x = 565, y = 175 }, Size = { Width = 201, Height = 128 }} end, 
        OnInteract = function() StartSequence( function() Say("So, The town is to the left.", 3.0) Say() end) end, 
        OnLook = function() StartSequence( function() Say("This sign looks very old", 3.0) Say() end) end} 
    },

    { Quad = { OnConstruct = function() return { NameId = "Fazenda Return", Cursor = "MRight", Pos = { x = 788, y = 145 }, 
        Size = { Width = 131, Height = 260 }} end, OnInteract = function() SwipeScene("TownPathDeep", "Left") end, 
        OnLook = function() StartSequence( function() Say("This way takes back to the Mansion", 3.0) Say() end) end} 
    },

    { Quad = { OnConstruct = function() return { NameId = "Town Entry", Cursor = "MLeft", Pos = { x = 0, y = 161 }, 
        Size = { Width = 195, Height = 340 }} end, OnInteract = function() SwipeScene("PlazaPan", "Right") end, 
        OnLook = function() StartSequence( function() Say("This way takes to the town", 3.0) Say() end) end} 
    },
}
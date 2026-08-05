return {
    { Entity = "TownPathBG", Textures = {
        {TownPathA = "data/Scenes/Parking/TownPathA.jpg"}, 
        {TownPathB = "data/Scenes/Parking/TownPathB.jpg"}, 
        {TownPathANight = "data/Scenes/Parking/TownPathANight.jpg"}, 
        {TownPathBNight = "data/Scenes/Parking/TownPathBNight.jpg"}}
    },


    { Quad = (function() 
        local self = { Locked = true }
        function self.OnConstruct() return { NameId = "Car back", Pos = { x = 445, y = 300 }, Size = { Width = 160, Height = 170 }} end

        function self.OnCombine(itemId)
            if (itemId == "CarKeys" and self.Locked) then
                self.Locked = false
            end 
        end

        function self.OnInteractComment() Say("\nThe car is locked", 3.0) Say() end
        function self.OnInteract() 
            if not self.Locked then 
                SwipeScene("Trunk", "Down")
            else
                StartSequence(self.OnInteractComment) 
            end
        end

        function self.OnLookComment() 
            Say("Thiago","Damn, where're my car keys?", 3.0)
            Say("Thiago","I'll need to look for them later", 4.0) 
            Say() 
        end
        function self.OnLook()
            StartSequence(self.OnLookComment) 
        end

        return self
        end)()
    },


    { Quad = { OnConstruct = function() return { NameId = "Car front", Pos = { x = 610, y = 300 }, 
        Size = { Width = 160, Height = 170 }} end, OnInteract = function() SwipeScene("Car", "Down") end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "TownPathLeft", NameView = "Left\nSide", Cursor = "MLeft",
        Clickable = true, Pos = { x = 0, y = 80 }, Size = { Width = 60, Height = 436 }} end, 
        OnInteract = function() SwipeScene("MansionSide", "Right") PlaySound("SwipeOut") end } 
    }, -- LEFT SIDE

    { Quad = { OnConstruct = function() return { NameId = "TownPathRight", NameView = "Right\nSide", Cursor = "MRight",
        Clickable = true, Pos = { x = 840, y = 0 }, Size = { Width = 80, Height = 516 }} end, 
        OnInteract = function() SwipeScene("RoadPath", "Left") PlaySound("SwipeIn") end }
    }, -- RIGHT SIDE

    { Quad = { OnConstruct = function() return { NameId = "Woods Path", Pos = { x = 215, y = 55 },  Cursor = "MUp",
        Size = { Width = 175, Height = 315 }} end, OnInteract = function() SwipeScene("TownPathDeep", "Down") end } 
    }

}

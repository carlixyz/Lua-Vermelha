return {
    { Entity = "CemeteryGate", Textures = "data/Scenes/Parking/CemeteryGate.jpg", Visible = true, Alpha = 1.0  },

    { Quad = (function() 
        local self = { Locked = true }
            function self.OnConstruct() return { NameId = "Old Gate", -- Cursor = "MUp",
                Pos = { x = 286, y = 165 }, Size = { Width = 192, Height = 276 }} end

            function self.OnCommentLook() Say("Looks like there's a key hole in the center", 5.0) Say() end

            function self.OnInteract() 
                if self.Locked == false then
                    SwipeScene("Cemetery", "Down") 
                else
                    StartSequence( function() Say("It's thightly closed as a submarine hatch", 4.0) Say() end)
                end
            end

            function self.OnLook()
                StartSequence(self.OnCommentLook)
            end

            function self.OnCombine(itemId)
                if (itemId == "CemeteryKey" and self.Locked == true) then
                    self.Locked = false
                    SetState("Bullets", "BSilver")
                    SetEntityCursor("Old Gate","MUp")
                    StartSequence(function() Say("Ok now it's unlocked'", 3.0) Say() end)
                end 
            end

        return self
        end)()
    },

    { Quad = (function() 
        local self = {}
        function self.OnConstruct() return { NameId = "Return to Road", Cursor = "MDown",
            Pos = { x = 0, y = 443 }, Size = { Width = 700, Height = 72 }} end
        function self.OnCommentLook() Say("This is the return back", 3.0) Say() end
        function self.OnInteract()  SwipeScene("RoadPath", "Up") PlaySound("SwipeIn")  end 
        return self
        end)()
    }

}
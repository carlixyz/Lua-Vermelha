return {
    { Entity = "CemeteryBG", Textures = "data/Scenes/Parking/Cemetery.jpg" },

    { Entity = "CemeteryGate", Textures = "data/Scenes/Parking/CemeteryGate.jpg", Visible = true, Alpha = 1.0  },

    { Quad = (function() 
        local self = {}
        function self.OnConstruct() return { NameId = "Old Gate", Cursor = "MUp",
            Pos = { x = 286, y = 165 }, Size = { Width = 192, Height = 276 }} end
        function self.OnCommentLook() Say("Looks like there's something mechanic here", 3.0) Say() end
        function self.OnInteract() SetVisible("CemeteryGate", false) end 
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
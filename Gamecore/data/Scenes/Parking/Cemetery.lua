return {
    { Entity = "Cemetery", Textures = "data/Scenes/Parking/Cemetery.jpg", Visible = true, Alpha = 1.0  },


    { Quad = (function() 
        local self = {}
        function self.OnConstruct() return { NameId = "Cemetery exit", Cursor = "MDown",
            Pos = { x = 0, y = 443 }, Size = { Width = 700, Height = 72 }} end
        function self.OnCommentLook() Say("This is the return back", 3.0) Say() end
        function self.OnInteract()  SwipeScene("RoadPath", "Up") PlaySound("SwipeIn")  end 
        return self
        end)()
    }

}
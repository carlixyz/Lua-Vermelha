return {
    { Entity = "BarInBG", Textures = {
        {BarInDay = "data/Scenes/Town/BarInDay.jpg"},
        {BarInNight = "data/Scenes/Town/BarInNight.jpg"}}
    },
    
    { Quad = { OnConstruct = function() return { NameId = "ReturnToBarOut", Cursor = "MUp", Pos = { x = 620, y = 70 }, 
        Size = { Width = 130, Height = 170 }} end, OnInteract = function() SwipeScene("BarOutside", "Down") end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "Drunk guy", Pos = { x = 780, y = 130 }, Size = { Width = 140, Height = 165 }} end,
        OnInteract = function() SetVisible("DrunkMan") end } 
    },


    { DrunkMan = (function() 
        local self = { Invite = false, Sleeping = false }
        function self.OnConstruct() 
            return { Clickable = false, Visible = false, Textures = {
                {DrunkIdle = "data/Scenes/Town/BBThinking.jpg"}, 
                {DrunkHappy = "data/Scenes/Town/BBHappy.jpg"}, 
                {DrunkShut = "data/Scenes/Town/BBA.jpg"}, 
                {DrunkTalk = "data/Scenes/Town/BBB.jpg"}, 
                {DrunkDrinks = "data/Scenes/Town/BBFondo.jpg"},
                {DrunkSleept = "data/Scenes/Town/BBHecho.jpg" }
            } } 
        end

        function self.OnEnter()
            SetVisible("DrunkMan", false)
        end

        function self.OnCombine(itemId)
            if (itemId == "Beer" and not self.Invite) then
                self.Invite = true
            end 
        end

        function self.OnInteractComment() Say("\n...", 3.0) Say() end
        function self.OnInteract() 
            if not self.Invite then 
                StartSequence(self.OnInteractComment)
            else
                StartSequence(self.OnOpenTalk)
            end
        end

        function self.OnLookComment() Say("\nHe doesn't look open to talk", 4.0) Say("\nMaybe a beer can smooth him a bit", 4.0) Say() end
        function self.OnLook()
            StartSequence(self.OnLookComment) 
        end

        function self.OnOpenTalk() 
            Say("\nHey, that was unexpected, thanks!", 4.0) 
            Say("\nSo it looks like You're not from here, I'm right?", 4.0) 
            Say() 
            end
        
        return self
        end)()
    }


}
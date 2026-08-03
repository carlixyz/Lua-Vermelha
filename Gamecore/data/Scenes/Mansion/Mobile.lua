return {

    { Quad = (function() 
        local self = { AnimID = 0, AnimFrame = 0, FramesCount = 7, Viewed = false }
        function self.OnConstruct() return { Clickable = true, NameId = "CellPhone Exit", Cursor = "MDown",
            Pos = { x = 0, y = 350 }, Size = { Width = 920, Height = 160 }} end

        function self.OnInteract()
            BlendScene("GuestRoom", 1)
            if not self.Viewed then
                self.Viewed = true
                StartSequence( function() IntroWakeup.CountItem() end)
            end
        end

        function self.OnInit()
            self.OnEnter()
            Schedule(3, "OnMobileComment")
        end

        function OnMobileComment()
            StartSequence( function() Say("No way to make it work", 4) Say("Now it's useless") Say() end)
        end

        function self.OnEnter()
            if self.AnimID == 0 then
                self.AnimID = ScheduleRepeat(0.75, "AnimateMobile", "CancelMobileAnim")
            end
        end

        function self.OnExit()
            self.StopAnim()
        end

        function self.StopAnim()
            if self.AnimID ~= 0 then
                CancelScheduled(self.AnimID)
                self.AnimID = 0
            end

            SetVisible("CellPhoneOn", false)
        end

        function AnimateMobile()
            if self.AnimFrame == 0 then
                SetVisible("CellPhoneOn", true)
                self.AnimFrame = 1.
                self.FramesCount = self.FramesCount -1
                if self.FramesCount <= 0 then
                    self.StopAnim()
                end
            else
                SetVisible("CellPhoneOn", false)
                self.AnimFrame = 0
            end
        end

        return self
    end)()
    },  -- SCENE EXIT

    { Entity = "CellPhoneOff", Visible = true, Clickable = false, Textures = "data/Scenes/Mansion/CellPhoneOff.jpg"},
    
    { Entity = "CellPhoneOn", Visible = true, Clickable = false, Textures = "data/Scenes/Mansion/CellPhoneOn.jpg"} 

}
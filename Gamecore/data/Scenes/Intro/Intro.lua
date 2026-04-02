return {
    { NightIntro = "data/Scenes/Intro/NightIntro.lua" },
    { Entity = "Black", Textures = { Black = "data/Images/Dark.png"} },
    { Entity = "JumpScare", Textures = "data/Scenes/Intro/JumpScare.jpg", Visible = false  },

    { Quad = 
        (function() 
            local self = {}
            function self.OnConstruct() 
                return { NameId = "Rear mirror", Position = { x = 90, y = 60 }, Size = { Width = 150, Height = 100 }, Active = false }
            end
            function self.OnInteractComment() Say("I don't need to thouch the mirror\n it's fine as it is", 4.0) Say() end
            function self.OnLookComment() Say("I can see a guy with my face and He looks very tired", 4.0) Say() end
            function self.OnInteract() StartSequence(self.OnInteractComment) end function self.OnLook() StartSequence(self.OnLookComment) end
            return self
        end)()
    }, -- REAR MIRROR

    { Quad = 
        (function() 
            local self = {}
            function self.OnConstruct() 
                return { NameId = "Fachade", Position = { x = 300, y = 100 }, Size = { Width = 250, Height = 280 }, Active = false }
            end
            function self.OnCommentEntry() Say("That door looks to be closed \n I should go to the open one instead", 5.0) Say() end
            function self.OnCommentLook() Say("Wow, This people seems to have money, \n maybe there's someone inside", 5.0) Say() end
            function self.OnInteract() StartSequence(self.OnCommentEntry) end function self.OnLook() StartSequence(self.OnCommentLook) end 
            return self
        end)()
    }, -- FACHADE

    { Quad = 
        (function()  
            local self = { ClickedOnce = false, Transition = false }
            function self.OnConstruct()
                return { NameId = "Door entry", Position = { x = 600, y = 100 }, Size = { Width = 200, Height = 280 }, Active = false }
            end
            function self.OnCommentLook() Say("Looks like someone forgot to lock a door\n perhaps the wind opened it.", 5.0) Say() end
            function self.OnLook() StartSequence(self.OnCommentLook) end
            function self.OnEnter() self.ClickedOnce = false end
            function self.OnCommentEnter() Say("rain just stopped, I guess now is the right time\n to leave the car and walk there", 5.0) Say() end
            function self.OnInteract()
                if not self.Transition then
                    if self.ClickedOnce then
                        self.Transition = true
                        SetAlpha("Dark", 0.0)
                        SetVisible("Dark", true)
                        Fade("Dark", 1.0, 5)

                        SetMusicVolume(0.75)
                        PlaySound("SeatbeltClick")
                        Schedule( 6.0, "SetCurrentScene", "IntroFinal")
                        Schedule( 8.0, "Fade", "Dark", 0.0, 3)
                    else
                        PlaySound("CarDoor")
                        Schedule( 0.5, "SetMusicVolume", 1.0)
                        --SetMusicVolume(1.0)

                        self.ClickedOnce = true
                        StartSequence(self.OnCommentEnter)
                    end
                end
            end 
            return self -- DOOR ENTRY
        end)() 
    }, -- DOOR ENTRY
}
return {
        
        { Entity = "7Moon", Position = { x = -100, y = -220 }, Textures = "data/Scenes/Intro/7thMoon.png", Visible = true, Alpha = 1.0  },
        { TitleText = (function() 
                local self = { MenuEnabled = false, StatusEnabled = true }
                function self.OnConstruct() return 
                { NameId = "7Title", Position = { x = 0, y = 0 }, Clickable = false, Visible = true, Alpha = 0.0, 
                Textures = { TITLETEXT = "data/Scenes/Intro/7thText.png"}, --CurrentImage = "data/Scenes/Intro/7thTitle.png" 
        }
        end



        -- Main entry point
        function self.DoOptionsMenu()
            Choice(
                { "" },
                { "Play",
                    function()
                        Say("So let's jump to the first chapter ", 1.0)
                        --SetThunder(false)
                        SetAlpha("Dark", 1)
                        BlendScene("GuestRoom")
                    end },

                { self.StatusEnabled, "Status",
                    function()
                        Say("You decide to see more options")
                        --SetThunder(false)
                        Say()
                        self.DoOptionsMenu()
                        --StartSequence(self.DoOptionsMenu)
                    end },

                { "Credits", 
                    function() 
                        Say("Made by Carlixyz", 3.5)
                        Say()
                        StartSequence(self.DoOptionsMenu)
                    end }
                
                --{ "Opt 4", function() Say("\n\n So We have Opt 4", 0.5) end }
            )
        end

        function self.OnScreenInput()
            --SetAlpha("7Title", 1.0)
            if GetAlpha("Dark") <= 0.5 and not MenuEnabled then
                MenuEnabled = true
                PlaySound("SwipeOut")

                StopTween("Dark")
                StopTween("7Title")
                Fade("Dark", 0, 1)
                Fade("7Title", 0.2, 1)

                SetShadeAlpha( 0.35)
                StartSequence(self.DoOptionsMenu)
            end
        end


        function self.OnInit()
            self.OnEnter()
        end

        function self.OnEnter()
        --SetAlpha("Dark", 0.0)
            SetEmotion("TDisabled")
            PlaySound("TitleFX")
            Fade("Dark", 0.0, 20)
            Fade("7Title", 1.0, 60)
            Move("7Moon", 0, -220, 220)
            SetShadeAlpha( 0)
        end

        function self.OnExit()
            --SetThunder(false)
        end

        return self
        end)()    
    },


}
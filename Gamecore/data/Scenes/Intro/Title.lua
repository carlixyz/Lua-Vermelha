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
                --{ "" },
                { "" },
                { "Play",
                    function()
                        Say("\n\n So let's jump to the first chapter ", 0.5)
                        SetAlpha("Dark", 1)
                        BlendScene("GuestRoom") 

                    end },

                { self.StatusEnabled, "Status",
                    function()
                        Say("You decide to see more options")
                        Say()
                    end }
            )
        end

        function self.OnScreenInput()
            --SetAlpha("7Title", 1.0)
            
            if not MenuEnabled then
                MenuEnabled = true
                PlaySound("SwipeOut")

                StopTween("7Title")
                StopTween("Dark")
                Fade("7Title", 0.35, 1)
                Fade("Dark", 0, 1)

                SetShadeAlpha( 0.35)
                StartSequence(self.DoOptionsMenu)

            end
        end


        function self.OnInit()
            --SetAlpha("Dark", 0.0)
            PlaySound("TitleFX")
            SetThunder(false)
            Fade("Dark", 0.0, 20)
            Fade("7Title", 1.0, 60)
            Move("7Moon", 0, -220, 220)
            SetShadeAlpha( 0)
        end

        function self.OnExit()
 
        end

        return self
        end)()    
    },


}
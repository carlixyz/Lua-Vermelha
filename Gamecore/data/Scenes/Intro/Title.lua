
local ThreadScenes = {
    Intro           = "Boot",
    MadWorld        = "GuestRoom",
    WoodMorning     = "WoodMorningIntro",
    Maneater        = "RoomRegina",
    CrimeWave       = "Jail",
    GhostsAgain     = "Dreamscape",
    BlindingLights  = "BlindingLightsIntro",
    BrainJar        = "BrainJarVision",
}


return {
        
    { Entity = "7Moon", Position = { x = -100, y = -220 }, Visible = true, Textures = {
        {TMoonPartial    = "data/Scenes/Intro/7thMoonPartial.jpg"}, 
        {TMoonHalf       = "data/Scenes/Intro/7thMoonHalf.jpg"}, 
        {TMoonRed        = "data/Scenes/Intro/7thMoonRed.jpg" } } --, CurrentImage = "TMoonPartial"
    },

        
    { TitleText = (function() 
        local self = { MenuEnabled = false, DemoMode = false, FirstOption = "Play" }
        function self.OnConstruct() return 
            { NameId = "7Title", Clickable = false, Visible = true, Alpha = 0.0, 
            Textures = { TITLETEXT = "data/Scenes/Intro/7thText.png"}}
        end

        function self.StartNextChapter()
            local newThread = "MadWorld"

            if IsThreadCompleted("MadWorld") then
                newThread = GetRandomNewThread()
            end

            if newThread ~= "" then
                StartThread(newThread)

                local scene = ThreadScenes[newThread]

                if scene then
                    BlendScene(scene)
                end
            end
        end

        -- Main entry point
        function self.DoOptionsMenu()
            --ForceThreadCompleted("MadWorld") # uncomment this for testing

            Choice(
                { "" },
                { self.FirstOption,
                    function()
                        PlaySound("Unload")
                        if self.DemoMode then
                            Say("Game still under development")
                            Say("Come back later")
                            self.DoOptionsMenu()
                        else
                            Say("So let's jump to the first chapter ", 1.1)
                            SetAlpha("Dark", 1)
                            self.StartNextChapter()
                            --BlendScene("GuestRoom")
                        end
                    end },

                { GetFlag("StatusEnabled"), "Status",
                    function()
                        SwipeScene("Status", "Down")
                        --return self.DoOptionsMenu()
                        --StartSequence(self.DoOptionsMenu)
                    end },

                { "Credits", 
                    function() 
                        RollCredits()
                        Say()
                        --self.DoOptionsMenu()
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
        
        function self.UpdateBackground()
            local completedThreads = GetCompletedThreadCount()

            if completedThreads < 2 then
                SetState("7Moon", "TMoonPartial")
            elseif completedThreads < 4 then
                Deinitialize("Flame")
                self.FirstOption = "Continue"
                SetState("7Moon", "TMoonHalf")
            else
                SetState("7Moon", "TMoonRed")
            end
        end

        function self.OnInit()
            ForceThreadCompleted("Intro")
            self.OnEnter()
            PlaySound("TitleFX")
            Fade("Dark", 0.0, 20)
            Fade("7Title", 1.0, 60)
            Move("7Moon", 0, -220, 220)
            SetShadeAlpha( 0)
        end

        function self.OnEnter()
            --SetAlpha("Dark", 0.0)
            print("Title.OnEnter()")
            self.UpdateBackground()
            SetEmotion("TDisabled")
        end

        function self.OnExit()
            --SetThunder(false)
        end

        return self
        end)()    
    },


}
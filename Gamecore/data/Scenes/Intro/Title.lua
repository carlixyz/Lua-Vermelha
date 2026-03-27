return {
        
    { Entity = "7Moon", Position = { x = -100, y = -220 }, Textures = "data/Scenes/Intro/7thMoon.png", Visible = true, Alpha = 1.0  },
    { TitleText = (function() 
            local self = { }
            function self.OnConstruct() return 
            { NameId = "7Title", Position = { x = 0, y = 0 }, Clickable = false, Visible = true, Alpha = 0.0, 
            Textures = { TITLETEXT = "data/Scenes/Intro/7thText.png"}, --CurrentImage = "data/Scenes/Intro/7thTitle.png" 
        }
        end

        function self.OnInit()
            --SetAlpha("Dark", 0.0)
            Fade("Dark", 0.0, 20)
            Fade("7Title", 1.0, 60)
            Move("7Moon", 0, -220, 220)
        end

        function self.OnExit()
 
        end

        return self
        end)()    
    },


}
return {
--[[

{ Entity = "HallwayInit", Position = { x = 0, y = 0 }, Textures = {
        {HallwayDay = "data/Scenes/Mansion/HallwayDay.jpg"}, 
        {HallwaySunset = "data/Scenes/Mansion/HallwaySunset.jpg"}, 
        {HallwayDusk = "data/Scenes/Mansion/HallwayDusk.jpg"}, 
        {HallwayNight = "data/Scenes/Mansion/HallwayNight.jpg" }} 
    },
]]   

    { HallwayInit = (function() 
            local self = { State = 1} -- State: 0 left, 1 center, 2 right
            function self.OnConstruct() return { NameId = "HallwayInit", Clickable = false, Pos = { x = -1071, y = 0 }, 
                Textures = {    {HallwayDay = "data/Scenes/Mansion/HallwayDay.jpg"}, 
                                {HallwaySunset = "data/Scenes/Mansion/HallwaySunset.jpg"}, 
                                {HallwayDusk = "data/Scenes/Mansion/HallwayDusk.jpg"}, 
                                {HallwayNight = "data/Scenes/Mansion/HallwayNight.jpg" }} } end

            function self.Update()
                --print("self state is " .. self.State)
                if self.State == 0 then
                    Move("HallwayInit", 0)
                    
                elseif self.State == 1 then
                    Move("HallwayInit", -1071)
                    
                elseif self.State == 2 then
                    Move("HallwayInit", -1991)
                    
                end
            end

            function self.GoLeft()
                --print("Go Left" )

                if (self.State > 0) then
                    self.State = self.State -1
                    self.Update()
                end
            end

            function self.GoRight() 
                --print("Go Right" )

                if (self.State < 2) then
                    self.State = self.State +1 
                    self.Update()
                end
            end

            return self
        end)()
    },


    { Entity = "MansionView", Textures = { MansionView = "data/Scenes/Mansion/GeneralViewpointSeg.jpg"}, Visible = false },

    { Quad = (function()
            local self = {}

            function self.OnConstruct()
                return {
                    NameId = "InitLSide", NameView = "Left\nSide",
                    Position = { x = 0, y = 0 }, Size = { Width = 60, Height = 516 }, Clickable = true
                }
            end

            function self.OnInteract()
                --Move("HallwayInit", 0)
                HallwayInit.GoLeft()
                PlaySound("SwipeOut")
                --SetClickable("IntroLeftSide", false)
                --SetClickable("IntroBackDoor")
            end

            return self
        end)()
    }, -- LEFT SIDE

    { Quad = (function()
            local self = {}

            function self.OnConstruct()
                return {
                    NameId = "InitRSide", NameView = "Right\nSide",
                    Position = { x = 840, y = 0 }, Size = { Width = 80, Height = 516 }, Clickable = true
                }
            end

            function self.OnInteract()
                --Move("HallwayInit", -604)
                HallwayInit.GoRight()
                SetInventory( true)

                PlaySound("SwipeIn")
                --SetClickable("IntroLeftSide")
                --SetClickable("IntroRightSide", false)
            end

            return self
        end)()
    }, -- RIGHT SIDE


    { Quad = { OnConstruct = function() return { NameId = "Lobby entry", Position = { x = 700, y = 300 },
        Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("Lobby", "Down") end } 
    }





}
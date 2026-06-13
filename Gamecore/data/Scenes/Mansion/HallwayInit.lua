return {

    { HallwayStart = (function() 
        local self = { State = 1} -- State: 0 left, 1 center, 2 right
        function self.OnConstruct() return { Clickable = false, Pos = { x = -1071, y = 0 }, 
            Textures = {    {HallwayDay = "data/Scenes/Mansion/HallwayDay.jpg"}, 
                            {HallwaySunset = "data/Scenes/Mansion/HallwaySunset.jpg"}, 
                            {HallwayDusk = "data/Scenes/Mansion/HallwayDusk.jpg"}, 
                            {HallwayNight = "data/Scenes/Mansion/HallwayNight.jpg" }} } end


        function self.OnInit()
            --SetInventory(true)
            print("self state is " .. self.State)
            Schedule( 1.0, "SetInventory", true)
            SetThunder(false)
            SetNoise(false)
        end

        function self.Update()
            if self.State == 0 then
                Move("HallwayStart", 0)
                Move("LobbyAccessHallway", 1840)
                --if GetVisible("Ada") and GetAlpha("Ada") then
                --    Move("Ada", 1460)
                --end
                    
            elseif self.State == 1 then
                Move("HallwayStart", -1071)
                Move("LobbyAccessHallway", 1240)
                --if GetVisible("Ada") and GetAlpha("Ada") then
                --    Move("Ada", 360)
                --end
                    
            elseif self.State == 2 then
                Move("HallwayStart", -1991)
                Move("LobbyAccessHallway", 320)
                --if GetVisible("Ada") and GetAlpha("Ada") then
                --    Move("Ada", -340)
                --end
            end
        end

        function self.GoLeft()
            if (self.State > 0) then
                self.State = self.State -1
                self.Update()
            end
        end

        function self.GoRight() 
            if (self.State < 2) then
                self.State = self.State +1 
                self.Update()
            end
        end

        return self
        end)()
    },

    --{ Entity = "MansionView", Textures = { MansionView = "data/Scenes/Mansion/GeneralViewpointSeg.jpg"}, Visible = false },

    { Quad = (function()
        local self = {}

        function self.OnConstruct()
            Scale("MansionView", 3, 3)
            
            return {
                NameId = "HallInitLSide", NameView = "Left\nSide", Cursor = "MLeft",
                Position = { x = 0, y = 80 }, Size = { Width = 60, Height = 436 }, Clickable = true
            }
        end

        function self.OnInteract()
            --Ada.StartTalk()
            HallwayStart.GoLeft()
            PlaySound("SwipeOut")
        end

        return self end)()
    }, -- LEFT SIDE

    { Quad = (function()
        local self = {}

        function self.OnConstruct()
            return {
                NameId = "HallInitRSide", NameView = "Right\nSide", Cursor = "MRight",
                Position = { x = 840, y = 0 }, Size = { Width = 80, Height = 516 }, Clickable = true
            }
        end

        function self.OnInteract() 
            --Ada.StopTalk()
            HallwayStart.GoRight() PlaySound("SwipeIn") end
        return self end)()
    }, -- RIGHT SIDE


    { Quad = { OnConstruct = function() return { NameId = "LobbyAccessHallway", NameView = "Lobby entry", Cursor = "MUp",
        Position = { x = 1240, y = 280 }, Size = { Width = 120, Height = 80 }} end, 
        OnInteract = function() SwipeScene("Lobby", "Down") end } 
    }



}
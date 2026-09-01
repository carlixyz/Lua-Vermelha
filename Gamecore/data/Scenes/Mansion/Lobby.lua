return {

    { LobbyInit = (function() 
        local self = { State = 0} -- State: 0 left, 1 right
        function self.OnConstruct() 
            return { Clickable = false, Pos = { x = 0, y = 0 }, 
                Textures = {    {LobbyDay = "data/Scenes/Mansion/LobbyDay.jpg"}, 
                                {LobbySunset = "data/Scenes/Mansion/LobbySunset.jpg"}, 
                                {LobbyDusk = "data/Scenes/Mansion/LobbyDusk.jpg"}, 
                                {LobbyNight = "data/Scenes/Mansion/LobbyNight.jpg" }} } 
        end

        function self.OnInit()
            Schedule( 1.0, "SetInventory", true)
            self.OnEnter()
        end

        function self.OnEnter()
            --[[
            ]]--
            if not IsEntityInScene("Ada","Lobby") then
                LobbyInit.GoRight()
                Schedule(1.0, "SetEntityScene", "Ada", "Lobby" )
                SetClickable("Ada")
                SetVisible("Ada")
                Ada.StopTalk()
            end
        end

        function self.Update()
            if self.State == 0 then
                Move("LobbyInit", 0)
                SetClickable("LobbyInitLSide", false)
                Move("HallwayStartReturn", 650)
                SetClickable("LobbyInitRSide", true)

                Move("Small Table", 160)
                Move("PianoStart", 520)
                Move("ClockStart", 1200)
                Move("PowerBoardStart", 1500)
                Move("FireplaceStart", 716)

                if IsEntityInScene("Ada", "Lobby") and GetVisible("Ada") and GetAlpha("Ada") then
                    Move("Ada", 1060)
                end

            elseif self.State == 1 then
                Move("LobbyInit", -604)
                SetClickable("LobbyInitLSide", true)
                Move("HallwayStartReturn", 55)
                SetClickable("LobbyInitRSide", false)

                Move("Small Table", -800)
                Move("PianoStart", -120)
                Move("ClockStart", 280)
                Move("PowerBoardStart", 820)
                Move("FireplaceStart", 110)

                if IsEntityInScene("Ada", "Lobby") and GetVisible("Ada") and GetAlpha("Ada") then
                    Move("Ada", 360)
                end
            end
        end

        function self.GoLeft()
            if (self.State > 0) then
                self.State = self.State -1
                self.Update()
            end
        end

        function self.GoRight() 
            if (self.State < 1) then
                self.State = self.State +1 
                self.Update()
            end
        end

        return self
        end)()
    },

    { Quad = { OnConstruct = function() return { NameId = "LobbyInitLSide", NameView = "Left\nSide", Cursor = "MLeft", 
        Clickable = true, Pos = { x = 0, y = 80 }, Size = { Width = 60, Height = 436 }} end, 
        OnInteract = function() LobbyInit.GoLeft() PlaySound("SwipeOut") end } 
    }, -- LEFT SIDE

    { Quad = { OnConstruct = function() return { NameId = "LobbyInitRSide", NameView = "Right\nSide", Cursor = "MRight", 
        Clickable = true, Pos = { x = 840, y = 0 }, Size = { Width = 80, Height = 516 }} end, 
        OnInteract = function() LobbyInit.GoRight() PlaySound("SwipeIn") end } 
    }, -- RIGHT SIDE

    { Quad = { OnConstruct = function() return { NameId = "Small Table",
        Clickable = true, Pos = { x = 160, y = 265 }, Size = { Width = 150, Height = 60 }} end, 
        OnInteract = function() BlendScene("LobbyTable", 1)  end,
        OnLook = function() StartSequence(function() Say("There's something on the table", 3.0) Say() end) end } 
    }, -- TABLE


    { Quad = { OnConstruct = function() return { NameId = "HallwayStartReturn", NameView = "Hallway return", Cursor = "MUp", 
        Clickable = true, Pos = { x = 650, y = 123 }, Size = { Width = 55, Height = 120 }} end, 
        OnInteract = function() SwipeScene("HallwayInit", "Down") end } 
    }, -- HALLWAY RETURN

    { Quad = { OnConstruct = function() return { NameId = "HouseExit", Cursor = "MDown", 
        Pos = { x = 100, y = 413 }, Size = { Width = 700, Height = 100 }, Clickable = true } end, 
        OnInteract = function() 
            if IsEntityInScene("MainKey", "Inventory") then
                PlaySound("DoorOpen")
                SwipeScene("MansionSide", "Up") 
                FadeMusic(0.25)
            else
                StartSequence( function() Say("Entry door is closed", 3.0) Say() end)
            end
        end,
        OnLook = function() StartSequence(function() Say("Maybe I can ask Ada to open it", 4.0)  Say() end) end } 
    }, -- HOUSE EXIT

    { Quad = { OnConstruct = function() return { NameId = "PianoStart", NameView = "Piano", Clickable = true, 
        Pos = { x = 520, y = 180 }, Size = { Width = 80, Height = 60 }} end,
        OnInteract = function() PlaySound("PianoMi") end,
        OnLook = function() StartSequence( 
            function() Say("It's a gorgeous Piano...", 3.0) Say("Sadly, I have no idea about music", 3.0) Say() 
        end) end } 
    }, -- PIANO

    { Quad = { OnConstruct = function() return { NameId = "FireplaceStart", NameView = "Fire place",
        Clickable = true, Pos = { x = 716, y = 133 }, Size = { Width = 120, Height = 120 }} end, 
        OnInteract = function() SwipeScene("Fireplace", "Down")  end,
        OnLook = function() StartSequence(function() Say("It's a fireplace with some decorations over", 4.0) Say() end) end } 
    }, -- FIRE PLACE

    { Quad = { OnConstruct = function() return { NameId = "ClockStart", NameView = "Clock", Clickable = true, 
        Pos = { x = 1200, y = 136 }, Size = { Width = 34, Height = 120 }} end, 
        OnLook = function() StartSequence(function() Say("Mhhh...", 3.0) 
        Say("The clock isn't moving anymore, weird,\n looks like it's broken", 6.0) Say() end) end } 
    }, -- CLOCK

    { Quad = { OnConstruct = function() return { NameId = "PowerBoardStart", NameView = "Power\nBoard", Clickable = true, 
        Pos = { x = 1500, y = 150 }, Size = { Width = 70, Height = 70 }} end, 
        OnInteract = function() StartSequence(function() Say("No way I'm touching that...", 3.0) Say() end) end,
        OnLook = function() StartSequence(function() Say("I've bad feelings about it...", 3.0) Say() end) end } 
    }, -- POWER BOARD

    { MansionKey = (function() local self = {}
        function self.OnConstruct() return {NameView = "Mansion Key", Textures = "data/Scenes/Inventory/MainKey.png", Visible = false } end
        function self.OnLookComment()
            Say("\nIt's the Mansion main Key", 4.0)
            Say()
        end
        function self.OnLook() StartSequence(self.OnLookComment) end
        return self
        end)() 
    }, -- MANSION MAIN DOOR KEY


}
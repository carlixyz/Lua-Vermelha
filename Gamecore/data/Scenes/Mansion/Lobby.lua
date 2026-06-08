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
            --self.GoLeft()
            --[[
            self.State = 0
            SetClickable("LobbyInitLSide", false)
            SetClickable("LobbyInitRSide", true)
            SetPosition("LobbyInit", 0)
            SetPosition("HallwayStartReturn", 650)
            SetPosition("PianoStart", 520)
            SetPosition("ClockStart", 1200)
            SetPosition("PowerBoardStart", 1500)
            SetPosition("FireplaceStart", 716)
            ]]--
        end

        function self.Update()
            if self.State == 0 then
                Move("LobbyInit", 0)
                SetClickable("LobbyInitLSide", false)
                Move("HallwayStartReturn", 650)
                SetClickable("LobbyInitRSide", true)

                Move("PianoStart", 520)
                Move("ClockStart", 1200)
                Move("PowerBoardStart", 1500)
                Move("FireplaceStart", 716)

            elseif self.State == 1 then
                Move("LobbyInit", -604)
                SetClickable("LobbyInitLSide", true)
                Move("HallwayStartReturn", 55)
                SetClickable("LobbyInitRSide", false)

                Move("PianoStart", -120)
                Move("ClockStart", 280)
                Move("PowerBoardStart", 820)
                Move("FireplaceStart", 110)
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

    { Quad = { OnConstruct = function() return { NameId = "HallwayStartReturn", NameView = "Hallway return", Cursor = "MUp", 
        Clickable = true, Pos = { x = 650, y = 123 }, Size = { Width = 55, Height = 120 }} end, 
        OnInteract = function() SwipeScene("HallwayInit", "Down") end } 
    }, -- HALLWAY RETURN

    { Quad = { OnConstruct = function() return { NameId = "House exit", Cursor = "MDown", Pos = { x = 215, y = 413 },
            Size = { Width = 590, Height = 100 }, Clickable = true } end, OnInteract = function() SwipeScene("MansionFront", "Up") end } 
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
        --OnInteract = function() BlendScene("Fireplace")  end,
        OnInteract = function() SwipeScene("Fireplace", "Down")  end,
        OnLook = function() StartSequence(function() Say("It's a fireplace with some decorations over", 4.0) Say() end) end } 
    }, -- FIRE PLACE

    { Quad = { OnConstruct = function() return { NameId = "ClockStart", NameView = "Clock", Clickable = true, 
        Pos = { x = 1200, y = 136 }, Size = { Width = 34, Height = 120 }} end, 
        OnLook = function() StartSequence(function() Say("Mhhh...", 3.0) 
        Say("The clock isn't moving anymore, weird,\n lookslike it's broken", 6.0) Say() end) end } 
    }, -- CLOCK

    { Quad = { OnConstruct = function() return { NameId = "PowerBoardStart", NameView = "Power\nBoard", Clickable = true, 
        Pos = { x = 1500, y = 150 }, Size = { Width = 70, Height = 70 }} end, 
        OnInteract = function() StartSequence(function() Say("No way I'm touching that...", 3.0) Say() end) end,
        OnLook = function() StartSequence(function() Say("I've bad feelings about it...", 3.0) Say() end) end } 
    }, -- POWER BOARD


}
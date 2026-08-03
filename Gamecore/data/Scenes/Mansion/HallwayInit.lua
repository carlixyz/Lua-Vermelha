return {

    { HallwayStart = (function() 
        local self = { State = 1 } -- State: 0 left, 1 center, 2 right
        function self.OnConstruct() return { Clickable = false, Pos = { x = -1071, y = 0 }, 
            Textures = {    
                {HallwayDay = "data/Scenes/Mansion/HallwayDay.jpg"}, 
                {HallwaySunset = "data/Scenes/Mansion/HallwaySunset.jpg"}, 
                {HallwayDusk = "data/Scenes/Mansion/HallwayDusk.jpg"}, 
                {HallwayNight = "data/Scenes/Mansion/HallwayNight.jpg" }
            } 
        } 
        end

        function self.OnInit()
            --SetInventory(true)
            self.Update()
            print("self state is " .. self.State)
            Schedule( 1.0, "SetInventory", true)
            SetThunder(false)
            SetNoise(false)
            IntroWakeup.FirstTime = false
            SetClickable("GuestRoomExitDoor", true)
        end

        function self.Update()
            if self.State == 0 then
                Move("HallwayStart", 0)
                Move("LobbyAccessHallway", 1840)
                Move("PoolAccess", 65)
                Move("FarmAccess", 520)
                Move("ViktorRoomDoor", 610)
                Move("LukaRoomDoor", 710)
                Move("IlsaRoomDoor", 810)

                Move("ReginaRoomDoor", 980)
                Move("MirrorHallway", 1287)
                Move("GuestRoomDoor", 1665)

                Move("AdaRoomDoor", 2040)
                    
            elseif self.State == 1 then
                Move("HallwayStart", -1071)
                Move("LobbyAccessHallway", 1240)

                Move("PoolAccess", -1005)
                Move("FarmAccess", -550)
                Move("ViktorRoomDoor", -460)
                Move("LukaRoomDoor", -360)
                Move("IlsaRoomDoor", -260)

                Move("ReginaRoomDoor", 60)
                Move("MirrorHallway", 367)
                Move("GuestRoomDoor", 745)

                Move("AdaRoomDoor", 1120)
                    
            elseif self.State == 2 then
                Move("HallwayStart", -1991)
                Move("LobbyAccessHallway", 320)

                Move("PoolAccess", -1995)
                Move("FarmAccess", -1470)
                Move("ViktorRoomDoor", -1380)
                Move("LukaRoomDoor", -1280)
                Move("IlsaRoomDoor", -1180)

                Move("ReginaRoomDoor", -860)
                Move("MirrorHallway", -550)
                Move("GuestRoomDoor", -175)

                Move("AdaRoomDoor", 200)

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


    { Quad = { OnConstruct = function() return { NameId = "PoolAccess", NameView = "Pool access",  Cursor = "MLeft",
        Pos = { x = 65, y = 300 }, Size = { Width = 275, Height = 100 }} end, 
        OnInteract = function() SwipeScene("Depot", "Right") end, 
        OnLook = function() StartSequence( function() Say("That door takes to a pool", 3.0) Say() end) end} 
    }, -- POOL's ACCESS

    { Quad = { OnConstruct = function() return { NameId = "FarmAccess", NameView = "Back access", Cursor = "MUp",
        Pos = { x = 520, y = 280 }, Size = { Width = 100, Height = 85 }} end, 
        OnInteract = function() SwipeScene("CorralExit", "Down") end, 
        OnLook = function() StartSequence( function() Say("I think that back door takes to the farm", 5.0) Say() end) end} 
    }, -- CORRAL FARM's ACCESS

    { Quad = { OnConstruct = function() return { NameId = "ViktorRoomDoor", NameView = "Viktor's Room",
        Pos = { x = 610, y = 280 }, Size = { Width = 70, Height = 85 }} end,  
        OnInteract = function() StartSequence( function() SwipeScene("ViktorKnob", "Down") Say() end) end, 
        OnLook = function() StartSequence( function() Say("I think that's Viktor's Room", 5.0) Say() end) end} 
    }, -- VIKTOR's'ROOM

    { Quad = { OnConstruct = function() return { NameId = "LukaRoomDoor", NameView = "Lukas Room",
        Pos = { x = 710, y = 290 }, Size = { Width = 30, Height = 80 }} end,  
        OnInteract = function() StartSequence( function() Say("I'll not try going there", 5.0) Say() end) end, 
        OnLook = function() StartSequence( function() Say("I think that's Lukas Room", 5.0) Say() end) end} 
    }, -- LUKA's ROOM

    { Quad = { OnConstruct = function() return { NameId = "IlsaRoomDoor", NameView = "Ilsa's Room",
        Pos = { x = 810, y = 260 }, Size = { Width = 26, Height = 130 }} end, 
        OnInteract = function() StartSequence( function() Say("I'll not try going there", 5.0) Say() end) end, 
        OnLook = function() StartSequence( function() Say("I think that's Ilsa's Room", 5.0) Say() end) end} 
    }, -- ILSA's'ROOM

    { Quad = { OnConstruct = function() return { NameId = "ReginaRoomDoor", NameView = "Regina's Room",
        Pos = { x = 60, y = 215 }, Size = { Width = 110, Height = 250 }} end, 
        OnInteract = function() StartSequence( function() Say("I'll not try going there", 5.0) Say() end) end, 
        OnLook = function() StartSequence( function() Say("I think that's Regina's Room", 5.0) Say() end) end} 
    }, -- REGINA's'ROOM

    { Quad = { OnConstruct = function() return { NameId = "MirrorHallway", NameView = "Mirror",
        Pos = { x = 367, y = 208 }, Size = { Width = 190, Height = 170 }} end, 
        OnInteract = function() StartSequence( function() Say("It's just a mirror, I'm not that narcissistic", 5.0) Say() end) end, 
        OnLook = function() StartSequence( function() Say("Who's that cool guy?\nOh right just so happens to be me haha", 5.0) Say() end) end} 
    }, -- MIRROR

    { Quad = { OnConstruct = function() return { NameId = "GuestRoomDoor", NameView = "Guest Room", Cursor = "MUp",
        Pos = { x = 745, y = 215 }, Size = { Width = 95, Height = 240 }} end, 
        OnInteract = function() StartSequence( function() SwipeScene("GuestRoom", "Down") Say() end) end, 
        OnLook = function() StartSequence( function() Say("This is supposed to be my room for the time being", 5.0) Say() end) end} 
    }, -- GUEST's ROOM

    { Quad = { OnConstruct = function() return { NameId = "AdaRoomDoor", NameView = "Ada's Room",
        Pos = { x = 200, y = 280 }, Size = { Width = 25, Height = 100 }} end, 
        OnInteract = function() StartSequence( function() Say("I don't want to go there right now", 5.0) Say() end) end, 
        OnLook = function() StartSequence( function() Say("I think that's Ada's Room", 5.0) Say() end) end} 
    }, -- ADA's ROOM

    { Quad = { OnConstruct = function() return { NameId = "LobbyAccessHallway", NameView = "Lobby entry", Cursor = "MUp",
        Position = { x = 1240, y = 280 }, Size = { Width = 120, Height = 80 }} end, 
        OnInteract = function() SwipeScene("Lobby", "Down") end } 
    } -- LOBBY ACCESS

}
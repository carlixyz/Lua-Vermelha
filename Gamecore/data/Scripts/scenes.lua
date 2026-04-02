
Scenes = {
    -- 920 - 512
    Boot = true,
    
    Inventory = "data/Scenes/Inventory/Inventory.lua",

    Global = {
        { Entity = "Shade", Textures = "data/Images/t.png", Alpha = 0.6, Position = { x = 0, y = 316 }, Visible = false },
        { Entity = "Dark", Textures = { Dark = "data/Images/Dark.png"}, Visible = false, Alpha = 1.0  }
        --{ Dark = { OnConstruct = function() return { NameId = "Dark", Visible = false, Active = false, Clickable = false,
        --          Alpha = 1.0, Textures = { { Dark = "data/Images/Dark.png" } }, CurrentImage = "Dark" } end } }
    },

    Road = {
        { NightDrive = "data/Scenes/Intro/NightDrive.lua" },
        { Entity = "Panel", Textures = "data/Images/t.png" , Alpha = 0.0, Position = { x = 0, y = 316 } },
        { Entity = "Flood", Textures = { Flood = "data/Scenes/Intro/Flood.jpg" }, Position = { x = -300, y = 80 }, Visible = true },
        { Entity = "Sign", Textures = { Sign = "data/Scenes/Intro/Sign.jpg" }, Position = { x = -300, y = 80 }, Visible = true },
        { Entity = "Indicator", Textures = { Indicator = "data/Scenes/Intro/Indicator.png" }, Position = { x = 25, y = 365 }, Visible = false },
        { Entity = "RearMirror", Position = { x = 900, y = -16 }, Textures = {
            {M1 = "data/Scenes/Intro/RearMirror.png"}, {M2 = "data/Scenes/Intro/RearMirror2.png"}, {M3 = "data/Scenes/Intro/RearMirror3.png" }} }
    },
    
    Intro = "data/Scenes/Intro/Intro.lua",

    IntroFinal = "data/Scenes/Intro/IntroFinal.lua",

    Title = "data/Scenes/Intro/Title.lua",

    "Credits",

    -----------------------------------------------------------------------------------------------------------------------------
    -- FIRST PATH -> SMALL TOWN BOY
    -----------------------------------------------------------------------------------------------------------------------------
    GuestRoom = "data/Scenes/Mansion/RoomGuest.lua",

    Hallway = {
        { Entity = "Hallway", Position = { x = 0, y = 0 }, Textures = {
            {HallwayDay = "data/Scenes/Mansion/HallwayDay.jpg"}, 
            {HallwaySunset = "data/Scenes/Mansion/HallwaySunset.jpg"}, 
            {HallwayDusk = "data/Scenes/Mansion/HallwayDusk.jpg"}, 
            {HallwayNight = "data/Scenes/Mansion/HallwayNight.jpg" }} 
        },

        { Entity = "MansionView", Textures = { MansionView = "data/Scenes/Mansion/GeneralViewpointSeg.jpg"}, Visible = false },

        { Quad = { OnConstruct = function() return { NameId = "Lobby entry", Position = { x = 700, y = 300 },
            Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("Lobby", "Down") end } 
        }
    },

    Lobby = {
        { Entity = "Lobby", Position = { x = 0, y = 0 }, Textures = {
            {LobbyDay = "data/Scenes/Mansion/LobbyDay.jpg"}, 
            {LobbySunset = "data/Scenes/Mansion/LobbySunset.jpg"}, 
            {LobbyDusk = "data/Scenes/Mansion/LobbyDusk.jpg"}, 
            {LobbyNight = "data/Scenes/Mansion/LobbyNight.jpg" }} 
        },

        { Quad = { OnConstruct = function() return { NameId = "Lobby exit", Position = { x = 600, y = 100 },
            Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("Park", "Down") end } 
        }
    },

    Park = {
        { Entity = "Park", Textures = {
            {ParkFrontDay = "data/Scenes/Parking/MansionDay.jpg"}, 
            {ParkFrontCloudy = "data/Scenes/Parking/MansionCloudy.jpg"}, 
            {ParkFrontSunset = "data/Scenes/Parking/MansionSunset.jpg"}, 
            {ParkFrontNight = "data/Scenes/Parking/MansionNight.jpg"}, 
            {ParkFrontLua = "data/Scenes/Parking/MansionLua.jpg"}}
        },

        { Entity = "ParkSide", Position = { x = 0, y = 0 }, Textures = "data/Scenes/Parking/FachadeSide.jpg", Visible = false, Alpha = 0.0  },
        { Entity = "ParkTop", Position = { x = 0, y = 0 }, Textures = "data/Scenes/Parking/ParkTop.jpg", Visible = false, Alpha = 0.0  },

        { Quad = { OnConstruct = function() return { NameId = "Park exit", Position = { x = 600, y = 100 },
            Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("ParkPath", "Down") end } 
        }
    },

    ParkPath = {
        { Entity = "Town Branch", Textures = {
            {TownPathDeep = "data/Scenes/Parking/TownPathDeep.jpg"}, 
            {TownPathA = "data/Scenes/Parking/TownPathA.jpg"}, 
            {TownPathB = "data/Scenes/Parking/TownPathB.jpg"}, 
            {TownView = "data/Scenes/Parking/TownView.jpg"}}
        },

        { Quad = { OnConstruct = function() return { NameId = "Woods Path", Position = { x = 600, y = 100 },
            Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("Cemetery", "Down") end } 
        }
    },

    Cemetery = {
        { Entity = "Cemetery", Textures = {
            {CemeteryOut = "data/Scenes/Parking/Sanctuary.jpg" },
            {CemeteryEntry = "data/Scenes/Parking/CemeteryGate.jpg"}, 
            {Cemetery = "data/Scenes/Parking/Cemetery.jpg"}}
        },

        { Quad = { OnConstruct = function() return { NameId = "Cemetery Gate", Position = { x = 600, y = 100 },
            Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("PlazaPan", "Down") end } 
        }
    },

    PlazaPan = {
        { Entity = "PlazaPan", Position = { x = 0, y = 0 }, Textures = {
            {PlazaPanDay = "data/Scenes/Town/PlazaPanDay.jpg"}, 
            {PlazaPanSunset = "data/Scenes/Town/PlazaPanSunset.jpg"}, 
            {PlazaPanNight = "data/Scenes/Town/PlazaPanNight.jpg"}, 
            {PlazaPanThug = "data/Scenes/Town/PlazaPanNightThugs.jpg"}, 
            {PlazaPanFire = "data/Scenes/Town/PlazaPanNightFire.jpg"}, 
            {PlazaPanLua = "data/Scenes/Town/PlazaPanLua.jpg" }} 
        },

        { Entity = "Thugs", Textures = {
            {ThugsFar = "data/Scenes/Town/ThugsFar.jpg"}, {ThugsNear = "data/Scenes/Town/ThugsFar.jpg"} }, Visible = false },

        { Quad = { OnConstruct = function() return { NameId = "Path ending", Position = { x = 600, y = 100 },
            Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("PlazaExit", "Down") end } 
        }
    },

    PlazaExit = {
        { Entity = "PlazaExit", Textures = {
            {PlazaExitDay = "data/Scenes/Town/PlazaExitDay.jpg"}, 
            {PlazaExitDusk = "data/Scenes/Town/PlazaExitSunset.jpg"}, 
            {PlazaExitSunset = "data/Scenes/Town/PlazaExitNight.jpg"}, 
            {PlazaExitNight = "data/Scenes/Town/PlazaExitLua.jpg" }} 
        },

        { Quad = { OnConstruct = function() return { NameId = "Tunnel entry", Position = { x = 600, y = 100 },
            Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("Luperta", "Down") end } 
        }
    },

    Luperta = {
        { Entity = "LupertaStatue", Textures = {
            {LupertaDayClosed = "data/Scenes/Town/LupertaDayClosed.jpg"},
            {LupertaDayOpen = "data/Scenes/Town/LupertaDayOpen.jpg"},
            {LupertaSunOff = "data/Scenes/Town/LupertaSunsetOff.jpg"},
            {LupertaSunOn = "data/Scenes/Town/LupertaSunsetOn.jpg" },
            {LupertaCloseUp = "data/Scenes/Town/LupertaSunsetCloseUp.jpg" }} 
        },

        { Quad = { OnConstruct = function() return { NameId = "Plaza Return", Position = { x = 600, y = 100 },
            Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("PlazaReturn", "Down") end } 
        }
    },

    PlazaReturn = {
        { Entity = "PlazaReturn", Textures = {
            {ReturnDay = "data/Scenes/Town/PlazaReturnDay.jpg"}, 
            {ReturnDusk = "data/Scenes/Town/PlazaReturnSunset.jpg"}, 
            {ReturnSunset = "data/Scenes/Town/PlazaReturnNight.jpg"}, 
            {ReturnNight = "data/Scenes/Town/PlazaReturnLua.jpg" }}
        },

        { Quad = { OnConstruct = function() return { NameId = "Fountain path", Position = { x = 600, y = 100 },
            Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("PlazaFountain", "Down") end } 
        }
    },

    PlazaFountain = {
        { Entity = "Fountain", Textures = {
            {FountainDay = "data/Scenes/Town/PlazaFountainDay.jpg"}, 
            {FountainDusk = "data/Scenes/Town/PlazaFountainSunset.jpg"}, 
            {FountainSunset = "data/Scenes/Town/PlazaFountainNight.jpg"}, 
            {FountainNight = "data/Scenes/Town/PlazaFountainLua.jpg" }} 
        },

        { Quad = { OnConstruct = function() return { NameId = "Path Hospital", Position = { x = 600, y = 100 },
            Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("Hospital", "Down") end } 
        }
    },

    Hospital = {
        { Entity = "Hospital", Textures = {
            {HospitalDay = "data/Scenes/Town/HospitalOutDay.jpg"}, 
            {HospitalNight = "data/Scenes/Town/HospitalOutNight.jpg"}, 
            {HospitalLua = "data/Scenes/Town/HospitalOutLua.jpg" }, 
            {Medic = "data/Scenes/Town/Medic.jpg" }} 
        },

        { Quad = { OnConstruct = function() return { NameId = "Bar side", Position = { x = 600, y = 100 },
            Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("Bar", "Down") end } 
        }
    },

    Bar = {
        { Entity = "Bar", Textures = {
            {BarOutDay = "data/Scenes/Town/BarOutDay.jpg"},
            {BarOutNight = "data/Scenes/Town/BarOutNight.jpg"},
            {BarOutLua = "data/Scenes/Town/BarOutLua.jpg" },
            {BarInDay = "data/Scenes/Town/BarInDay.jpg" },
            {BarInNight = "data/Scenes/Town/BarInNight.jpg" },
            {Drunk = "data/Scenes/Town/Drunk.jpg" }}
        },

        { Quad = { OnConstruct = function() return { NameId = "Path entry", Position = { x = 600, y = 100 },
            Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("PlazaPan", "Down") end } 
        }
    },

    -----------------------------------------------------------------------------------------------------------------------------

    End = false
}



-- Set here the first scene to Initialize
--Scenes.StartScene = "Intro"
--Scenes.StartScene = "Boot"
Scenes.StartScene = "Title"
--Scenes.StartScene = "GuestRoom"

-- Set here a top access scene to have shared access
Scenes.SharedScene = "Global"
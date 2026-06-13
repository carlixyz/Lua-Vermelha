
Scenes = {
    -- 920 - 512
    Boot = true,
    
    Inventory = "data/Scenes/Inventory/Inventory.lua",

    Global = {
        { Entity = "Shade", Textures = "data/Images/t.png", Alpha = 0.6, Position = { x = 0, y = 316 }, Visible = false },
        { Ilsa = "data/Actors/Ilsa/Ilsa.lua" },
        { Ada = "data/Actors/Ada/Ada.lua" },
        { MansionView = "data/Scenes/Mansion/GeneralViewpoint.lua" },
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

    HallwayInit = "data/Scenes/Mansion/HallwayInit.lua",

    Lobby = "data/Scenes/Mansion/Lobby.lua",

    Fireplace = "data/Scenes/Mansion/Fireplace.lua",

    -------------------------------------------------

    MansionFront = "data/Scenes/Parking/MansionFront.lua",

    MansionSide = "data/Scenes/Parking/MansionSide.lua",

    RoadPath = "data/Scenes/Parking/RoadPath.lua", --

    Cemetery = "data/Scenes/Parking/Cemetery.lua", --

    Car = "data/Scenes/Parking/Car.lua",

    Trunk = "data/Scenes/Parking/Trunk.lua",

    TownPath = "data/Scenes/Parking/TownPath.lua", -- **********

    TownPathDeep = "data/Scenes/Parking/TownPathDeep.lua",

    TownView = "data/Scenes/Parking/TownView.lua",

    -------------------------------------------------

    PlazaPan = "data/Scenes/Town/PlazaPan.lua",

    PlazaExit = "data/Scenes/Town/PlazaExit.lua",

    Tunnel = "data/Scenes/Town/Tunnel.lua",

    Luperta = "data/Scenes/Town/Luperta.lua",

    PlazaReturn = "data/Scenes/Town/PlazaReturn.lua",

    PlazaFountain = "data/Scenes/Town/PlazaFountain.lua",

    HospitalOutside = "data/Scenes/Town/TownHospitalOut.lua",

    HospitalInside = "data/Scenes/Town/TownHospitalIn.lua",

    BarOutside = "data/Scenes/Town/TownBarOut.lua",

    BarInside = "data/Scenes/Town/TownBarIn.lua",

    -----------------------------------------------------------------------------------------------------------------------------

    End = false
}



-- Set here the first scene to Initialize


Scenes.StartScene = "HallwayInit"
--Scenes.StartScene = "Boot"
--Scenes.StartScene = "Intro"
--Scenes.StartScene = "Title"
--Scenes.StartScene = "GuestRoom"
--Scenes.StartScene = "MansionFront"
--Scenes.StartScene = "TownPathDeep"

-- Set here a top access scene to have shared access
Scenes.SharedScene = "Global"
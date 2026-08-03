
Scenes = {
    -- 920 - 512
    Boot = true,
    
    Inventory = "data/Scenes/Inventory/Inventory.lua",

    Global = {
        { Entity = "Shade", Textures = "data/Images/t.png", Alpha = 0.6, Position = { x = 0, y = 316 }, Visible = false },
        { Ilsa = "data/Actors/Ilsa/Ilsa.lua" },
        { Ada = "data/Actors/Ada/Ada.lua" },
        { MansionView = "data/Scenes/Mansion/GeneralViewpoint.lua" },
        { Entity = "Dark", Textures = { Dark = "data/Images/Dark.png"}, Visible = false, Alpha = 1.0  },
        --{ NightRun = "data/Intro/NightRun/NightRun.lua" },
        { Flame = "data/Intro/Flame/flame.lua" },
        { Woods = "data/Intro/Woods/woods.lua" },

        { Entity = "Babel", Textures = "data/Scenes/Psycho/Babel.jpg", Visible = false},
        { Entity = "Bete", Textures = "data/Scenes/Psycho/BeteDuGevaudan.jpg", Visible = false},
        { Entity = "Goya", Textures = "data/Scenes/Psycho/Goya.jpg", Visible = false},
        { Entity = "Picnic", Textures = "data/Scenes/Psycho/Picnic.jpg", Visible = false},
        { Entity = "DogPool", Textures = "data/Scenes/Psycho/DogPool.jpg", Visible = false},
        { Entity = "lobo", Textures = "data/Scenes/Psycho/lobo.jpg", Visible = false},
        { Entity = "Medieval", Textures = "data/Scenes/Psycho/Medieval.jpg", Visible = false},
        { Entity = "Navajo", Textures = "data/Scenes/Psycho/Navajo.jpg", Visible = false},
        { Entity = "Churrasco", Textures = "data/Scenes/Psycho/Churrascaria.jpg", Visible = false},

        { Entity = "SaintChris", Textures = "data/Scenes/Psycho/SaintChristopher.jpg", Visible = false},
        { Entity = "SkinWalker", Textures = "data/Scenes/Psycho/SkinWalker.jpg", Visible = false},
        { Entity = "SotricalJacobs", Textures = "data/Scenes/Psycho/SotricalJacobs.jpg", Visible = false},
        { Entity = "DogHead", Textures = "data/Scenes/Psycho/DogHead.jpg", Visible = false},
        { Entity = "Tableau", Textures = "data/Scenes/Psycho/Tableau.jpg", Visible = false},
        { Entity = "Templars", Textures = "data/Scenes/Psycho/Templars.jpg", Visible = false},
        { Entity = "woodcut", Textures = "data/Scenes/Psycho/woodcut.jpg", Visible = false},
        { Entity = "Zeus", Textures = "data/Scenes/Psycho/Zeus.jpg", Visible = false},
        { Entity = "Lua", Textures = "data/Scenes/Psycho/LuaVermelha.jpg", Visible = false},

        { Entity = "Paraoh", Textures = "data/Scenes/Psycho/Paraoh.jpg", Visible = false},
        { Entity = "Lagart", Textures = "data/Scenes/Psycho/Lagart.jpg", Visible = false},
        { Entity = "Skull.jpg", Textures = "data/Scenes/Psycho/Skull.jpg", Visible = false},
        { Entity = "LegInjury", Textures = "data/Scenes/Psycho/LegInjury.jpg", Visible = false},
        { Entity = "SmallEye", Textures = "data/Scenes/Psycho/EyeS.jpg", Visible = false},
        { Entity = "BigEye", Textures = "data/Scenes/Psycho/EyeXL.jpg", Visible = false}
        -- { Psycho = "data/Scenes/Psycho/Psycho.lua" } -- Doesn't work, it's an entity not a scene

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

    Credits = "data/Scenes/Intro/Credits.lua",

    -----------------------------------------------------------------------------------------------------------------------------
    -- FIRST PATH -> SMALL TOWN BOY
    -----------------------------------------------------------------------------------------------------------------------------

    GuestRoom = "data/Scenes/Mansion/RoomGuest.lua",

    WindowTree = "data/Scenes/Mansion/WindowTree.lua",

    Mobile = "data/Scenes/Mansion/Mobile.lua",

    HallwayInit = "data/Scenes/Mansion/HallwayInit.lua",

    ViktorKnob = "data/Scenes/Mansion/ViktorDoor.lua",

    Depot = "data/Scenes/Mansion/Depot.lua",

    CorralExit = "data/Scenes/Mansion/CorralExit.lua",

    Lobby = "data/Scenes/Mansion/Lobby.lua",

    Fireplace = "data/Scenes/Mansion/Fireplace.lua",

    LobbyTable = "data/Scenes/Mansion/LobbyTable.lua",

    FamilyPhoto = "data/Scenes/Mansion/FamilyPhoto.lua",

    -------------------------------------------------

    MansionFront = "data/Scenes/Parking/MansionFront.lua",

    MansionSide = "data/Scenes/Parking/MansionSide.lua",

    RoadPath = "data/Scenes/Parking/RoadPath.lua", --

    CemeteryGate = "data/Scenes/Parking/CemeteryGate.lua", --

    Cemetery = "data/Scenes/Parking/Cemetery.lua", --

    Car = "data/Scenes/Parking/Car.lua",

    Trunk = "data/Scenes/Parking/Trunk.lua",

    TownPath = "data/Scenes/Parking/TownPath.lua", -- **********

    TownPathDeep = "data/Scenes/Parking/TownPathDeep.lua",

    TownView = "data/Scenes/Parking/TownView.lua",

    -------------------------------------------------

    PlazaPan = "data/Scenes/Town/PlazaPan.lua",

    PlazaExit = "data/Scenes/Town/PlazaExit.lua",

    PlazaBoard = "data/Scenes/Town/PlazaBoard.lua",

    PlazaThugs = "data/Scenes/Town/PlazaThugs.lua",

    Tunnel = "data/Scenes/Town/Tunnel.lua",

    Luperta = "data/Scenes/Town/Luperta.lua",

    PlazaReturn = "data/Scenes/Town/PlazaReturn.lua",

    PlazaFountain = "data/Scenes/Town/PlazaFountain.lua",

    HospitalOutside = "data/Scenes/Town/TownHospitalOut.lua",

    HospitalInside = "data/Scenes/Town/TownHospitalIn.lua",

    BarOutside = "data/Scenes/Town/TownBarOut.lua",

    BarInside = "data/Scenes/Town/TownBarIn.lua",

    BarDrunk = "data/Scenes/Town/TownBarDrunk.lua",

    -----------------------------------------------------------------------------------------------------------------------------

    End = false
}



---| Set here the first scene to Initialize |---


Scenes.StartScene = "GuestRoom"
--Scenes.StartScene = "Fireplace"

--Scenes.StartScene = "HallwayInit"
--Scenes.StartScene = "Boot"
--Scenes.StartScene = "Intro"
--Scenes.StartScene = "Title"
--Scenes.StartScene = "Lobby" -- REMOVE FORCED ADA
--Scenes.StartScene = "MansionSide"
--Scenes.StartScene = "BarInside"
--Scenes.StartScene = "TownPathDeep"
--Scenes.StartScene = "PlazaThugs"
--Scenes.StartScene = "PlazaPan"

-- Set here a top access scene to have shared access
Scenes.SharedScene = "Global"
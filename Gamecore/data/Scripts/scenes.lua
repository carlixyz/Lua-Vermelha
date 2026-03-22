
Scenes = {
    -- 920 - 516
    Boot = true,
    
    Inventory = {
        { Entity = "Med", Position = { x = 32, y = 32 }, Textures = "data/Scenes/Inventory/Medication.png", Clickable = true},
        { Entity = "MainKey", Position = { x = 128, y = 32 }, Textures = "data/Scenes/Inventory/MainKey.png", Clickable = true},
        { Entity = "Knife", Position = { x = 256, y = 32 }, Textures = "data/Scenes/Inventory/Knife.png", Clickable = true},
    },

    Global = {
        --{ Entity = "Shade", Textures = "data/Images/t.png", Alpha = 1.0, Position = { x = 0, y = 316 }, Visible = false },
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
    
    Intro = {
        { NightIntro = "data/Scenes/Intro/NightIntro.lua" },
        { Entity = "Black", Textures = { Black = "data/Images/Dark.png"} },
        { Entity = "JumpScare", Textures = "data/Scenes/Intro/JumpScare.jpg", Visible = false  },

        { 
            Quad = (function() 
                local self = {}
                function self.OnConstruct() 
                    return { NameId = "Rear mirror", Position = { x = 90, y = 60 }, Size = { Width = 150, Height = 100 }, Active = false }
                end
                function self.OnInteractComment() Say("I don't need to thouch the mirror\n it's fine as it is", 4.0) Say() end
                function self.OnLookComment() Say("I can see a guy with my face and He looks very tired", 4.0) Say() end
                function self.OnInteract() StartSequence(self.OnInteractComment) end function self.OnLook() StartSequence(self.OnLookComment) end
                return self
            end)()
        }, -- REAR MIRROR

        { 
            Quad = (function() 
                local self = {}
                function self.OnConstruct() 
                    return { NameId = "Fachade", Position = { x = 300, y = 100 }, Size = { Width = 250, Height = 280 }, Active = false }
                end
                function self.OnCommentEntry() Say("That door looks to be closed \n I should go to the open one instead", 5.0) Say() end
                function self.OnCommentLook() Say("Wow, This people seems to have money, \n maybe there's someone inside", 5.0) Say() end
                function self.OnInteract() StartSequence(self.OnCommentEntry) end function self.OnLook() StartSequence(self.OnCommentLook) end 
                return self
            end)()
        }, -- FACHADE

        { 
            Quad = (function()  
                local self = { ClickedOnce = false }
                function self.OnConstruct()
                    return { NameId = "Door entry", Position = { x = 600, y = 100 }, Size = { Width = 200, Height = 280 }, Active = false }
                end
                function self.OnCommentLook() Say("Looks like someone forgot to lock a door\n perhaps the wind opened it.", 5.0) Say() end
                function self.OnLook() StartSequence(self.OnCommentLook) end
                function self.OnCommentEnter() Say("rain just stopped, I guess now is the right time\n to leave the car and walk there", 5.0) Say() end
                function self.OnInteract()
                    if self.ClickedOnce then
                        SetAlpha("Dark", 0.0)
                        SetVisible("Dark", true)
                        Fade("Dark", 1.0, 2)
                        Schedule( 2.1, "SetCurrentScene", "IntroFinal")
                        Schedule( 3.0, "Fade", "Dark", 0.0, 3)
                    else
                        self.ClickedOnce = true
                        StartSequence(self.OnCommentEnter) 
                    end
                end 
                return self -- DOOR ENTRY 
            end)() 
        }, -- DOOR ENTRY
    },

    IntroFinal = {

        { Entity = "IntroLobby", Position = { x = 0, y = 0 }, Textures = {
            {I1 = "data/Scenes/Intro/LobbyIntroLight.jpg"}, {I2 = "data/Scenes/Intro/LobbyIntroDark.jpg"}, {I3 = "data/Scenes/Intro/LobbyIntroThunder.jpg" }} 
        },
        { Entity = "ElectricBoard", Position = { x = 670, y = 90 }, Textures = "data/Scenes/Intro/PowerPanel.jpg", Visible = false },
        { Entity = "IntroWolf", Position = { x = -194, y = -206 }, Textures = "data/Scenes/Intro/IntroWolf.jpg", Visible = false  },
        { Entity = "Seventh", Position = { x = -100, y = -220 }, Textures = "data/Scenes/Intro/SeventhFractal.png", Visible = false, Alpha = 0.0  },
     
        { Quad = (function() 
                local self = {}
                function self.OnConstruct() 
                    return { NameId = "Left\nSide", Position = { x = 0, y = 0 }, Size = { Width = 60, Height = 516 }, Clickable = false }
                end
                function self.OnInteract() 
                Move("IntroLobby",0)  SetClickable("Left\nSide", false) SetClickable("Right\nSide") SetClickable("Clock", false)  
                    SetClickable("Right Windows", false) SetClickable("Table ", false) SetClickable("Power\nBoard", false)
                    SetActive("Back Door") SetClickable("Piano") SetClickable("Small Table ") SetClickable("Left Windows")

                end 
                return self
            end)() 
        }, -- LEFT SIDE   

        { 
        Quad = (function() 
                local self = {}
                function self.OnConstruct()
                    return { NameId = "Left Windows", Position = { x = 80, y = 80 }, Size = { Width = 400, Height = 150 }, Active = true }
                end
                function self.OnComment() Say("The rain stopped a bit,\nbut the thunders keeps flashing like a rave.", 5.0) Say() end
                function self.OnInteract() StartSequence(self.OnComment) end function self.OnLook() StartSequence(self.OnComment) end 
                return self end)()
        }, -- Left windows
        
        { 
        Quad = (function() 
                local self = {}
                function self.OnConstruct() 
                    return { NameId = "Small Table ", Position = { x = 210, y = 260 }, Size = { Width = 130, Height = 90 }, Active = true }
                end
                function self.OnCommentEntry() Say("A small table with a decoration bowl and some books\nCan't read nothing'", 6.0) Say() end
                function self.OnInteract() StartSequence(self.OnCommentEntry) end function self.OnLook() StartSequence(self.OnCommentEntry) end 
                return self end)()
        }, -- Small Table

        { 
        Quad = (function() 
                local self = {}
                function self.OnConstruct() 
                    return { NameId = "Back Door", Position = { x = 655, y = 114 }, Size = { Width = 55, Height = 120 }, Active = true }
                end
                function self.OnCommentEntry() Say("There's a door there but is closed \nand I don't see a key anywhere", 5.0) Say() end
                function self.OnInteract() StartSequence(self.OnCommentEntry) end function self.OnLook() StartSequence(self.OnCommentEntry) end 
                return self end)()
        }, -- Back Door

        { 
        Quad = (function() 
                local self = {}
                function self.OnConstruct() 
                    return { NameId = "Piano", Position = { x = 520, y = 180 }, Size = { Width = 80, Height = 60 }, Active = true }
                end
                function self.OnComment() Say("I think there's a piano in the other side of the room", 5.0) Say("I'm not going to touch that", 3.0) Say() end
                function self.OnInteract() StartSequence(self.OnComment) end function self.OnLook() StartSequence(self.OnComment) end 
                return self end)()
        }, -- Piano


        { 
        Quad = (function() 
                local self = {}
                function self.OnConstruct() 
                    return { NameId = "Right\nSide", Position = { x = 840, y = 0 }, Size = { Width = 80, Height = 516 }, Clickable = true }
                end
                function self.OnInteract() 
                    Move("IntroLobby",-604)  SetClickable("Left\nSide") SetClickable("Right\nSide", false) SetClickable("Clock", true)  
                    SetClickable("Right Windows", true) SetClickable("Table ", true) SetClickable("Power\nBoard", true)
                    SetActive("Back Door", false) SetClickable("Piano", false) SetClickable("Small Table ", false) SetClickable("Left Windows", false)
                end 
                return self 
            end)()
        }, -- RIGHT SIDE

        { 
        Quad = (function() 
                local self = {}
                function self.OnConstruct() 
                    return { NameId = "Right Windows", Position = { x = 360, y = 96 }, Size = { Width = 410, Height = 150 }, Clickable = false }
                end
                function self.OnComment() Say("Between flashes of lighting, I can glimpse some trees\nswaying in the darkness of the night...", 6.0) Say() end
                function self.OnInteract() StartSequence(self.OnComment) end function self.OnLook() StartSequence(self.OnComment) end 
                return self end)()
        }, -- Right windows

        { 
        Quad = (function() 
                local self = {}
                function self.OnConstruct() 
                    return { NameId = "Clock", Position = { x = 280, y = 130 }, Size = { Width = 20, Height = 100 }, Clickable = false }
                end
                function self.OnCommentEntry() Say("Something is ticking there..\nI guess We're safe for now", 6.0) Say() end
                function self.OnInteract() StartSequence(self.OnCommentEntry) end function self.OnLook() StartSequence(self.OnCommentEntry) end 
                return self end)()
        }, -- CLOCK
        
        { 
        Quad = (function() 
                local self = {}
                function self.OnConstruct() 
                    return { NameId = "Table ", Position = { x = 310, y = 260 }, Size = { Width = 160, Height = 60 }, Clickable = false }
                end
                function self.OnCommentEntry() Say("There's a cup of wine and something slimey\nI can't see nothing really", 6.0) Say() end
                function self.OnInteract() StartSequence(self.OnCommentEntry) end function self.OnLook() StartSequence(self.OnCommentEntry) end 
                return self end)()
        }, -- Table

        
        { 
        Quad = (function() 
                local self = { ClickedOnce = false, ClickedTwice = false, Timer = 16.0, ThunderCancelID = 0 }
                function AlternateThunders()
                    self.Timer = self.Timer - 1.0
                    if self.Timer <= 0.0 then 
                        self.Timer = 8.0
                        Schedule( 1.0, "SetState", "IntroLobby", "I3")
                        Schedule( 1.2, "SetState", "IntroLobby", "I2")

                        Schedule( 1.4, "SetState", "IntroLobby", "I3")
                        Schedule( 1.6, "SetState", "IntroLobby", "I2")

                        Schedule( 1.8, "SetState", "IntroLobby", "I3")
                        Schedule( 2.0, "SetState", "IntroLobby", "I2")

                        Schedule(3, "TriggerThunder", 2)
                    end
                end
                function self.OnConstruct() 
                    return { NameId = "Power\nBoard", Position = { x = 820, y = 150 }, Size = { Width = 70, Height = 70 }, Clickable = false }
                end
                function self.OnScreenInput() 
                    if self.ClickedOnce == false then
                        self.ThunderCancelID = ScheduleRepeat( 1, "AlternateThunders", "ThunderCancelID")
                        self.ClickedOnce = true
                        SetState("IntroLobby", "I2") 
                        StartSequence(self.OnLightsOut) 
                        Schedule(3, "TriggerThunder", 2)
                    end
                end
                function self.OnLightsOut() Say("Damn, what just happened?", 3.0) Say("I can't see a thing!", 3.0) Say() end
                function self.OnBoardEntry() 
                    if not self.ClickedTwice then
                        Say("Let's see if I can fix the lights here...", 5.0) 
                        SetVisible("ElectricBoard")
                        Say()
                        self.ClickedTwice = true
                    else
                        SetClickable("ElectricBoard", false)
                        Fade("ElectricBoard", 0.0, 3.0)
                        Say("Ohh everything is already enabled here", 3.0) 
                        Say("I guess it's a general outagge...", 3.0) 
                        Say()
                        SetClickable("Left\nSide", false) SetClickable("Power\nBoard", false)
                        SetClickable("Table " , false) SetClickable("Right Windows", false) SetClickable("Clock", false) 
                        Schedule(4.0, "SetVisible", "IntroWolf")
                        Schedule(4.0, "Shake", "IntroWolf", 64.0, 2.0)
                        Schedule(4.5, "SetVisible", "Dark") 
                        Schedule(4.5, "Fade", "Dark", 1.0, 1.0)
                        Schedule(6.0, "SetVisible", "IntroLobby", false)
                        Schedule(6.0, "SetVisible", "IntroWolf", false)
                        SetVisible("Seventh")
                        Schedule(6.0, "SetAlpha", "Dark", 0.0)
                        Schedule(9.0, "Fade", "Seventh", 1.0, 60.0) 
                        Schedule(9.5, "Move", "Seventh", 0, -220, 220.0)
                    end
                end

                function self.OnInteract() StartSequence(self.OnBoardEntry) end function self.OnLook() StartSequence(self.OnBoardEntry) end 
                return self end)()
        }, -- ELECTRIC BOARD
    },

    Title = {
        { Entity = "7Title", Position = { x = -100, y = -220 }, Textures = "data/Scenes/Intro/SeventhFractal.png", Visible = false, Alpha = 0.0  },
        { Entity = "7Moon", Position = { x = -100, y = -220 }, Textures = "data/Scenes/Intro/SeventhFractal.png", Visible = false, Alpha = 0.0  },
     },

    "Credits",

    -----------------------------------------------------------------------------------------------------------------------------
    -- FIRST PATH -> SMALL TOWN BOY
    -----------------------------------------------------------------------------------------------------------------------------
    GuestRoom = {
        { Entity = "GuestRoom", Textures = { GuestRoom = "data/Scenes/Mansion/RoomGuest.jpg"} },
        { Entity = "AerialView", Textures = { AerialView = "data/Scenes/Mansion/GeneralViewpoint.jpg"}, Visible = false },

        { Quad = (function() 
                local self = {}
                function self.OnConstruct() 
                    return { NameId = "HideDoorA", NameView = "Hidden Door", Pos = { x = 90, y = 60 }, Size = { Width = 150, Height = 100 } }
                end
                function self.OnInteractComment() Say("Ohh there's a hidden door behind \n although is locked from the other side", 4.0) Say() end
                function self.OnLookComment() Say("This rupest tapestry is covering an opening behind", 4.0) Say() end
                function self.OnInteract() StartSequence(self.OnInteractComment) end function self.OnLook() StartSequence(self.OnLookComment) end
                return self
            end)()
        }, -- LOCKED DOOR
        
        { Quad = { OnConstruct = function() return { NameId = "GuestExit", NameView = "Exit", Position = { x = 390, y = 400 },
            Size = { Width = 150, Height = 150 }} end, OnInteract = function() SwipeScene("Hallway", "Down") end } 
        }
    },

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

    End = false,

    Test = { 
        { Fountain = "data/Scripts/fountain.lua" },
        --{ Door = "data/Scripts/door.lua" }

        --{ MansionDoor = { Locked = false, NextScene = "Boot", OnConstruct = function() 
        --    return { NameId = "MansionDoor", Position = { x = 0, y = 0 }, Textures = { Cuac = "data/Scenes/Intro/quad.png" }} end,
        --    OnInteract = function() if MansionDoor.Locked == false then SwipeScene(MansionDoor.NextScene, "Down") end end }
        --},

        { GardenDoor = { OnConstruct = function() return { NameId = "GardenDoor", Position = { x = 0, y = 0 }, 
            Textures = { Cuac = "data/Scenes/Intro/quad.png" }} end, OnInteract = function() SwipeScene("Road", "Down") end } 
        },

        { Quad = { OnConstruct = function() return { NameId = "Garden", Position = { x = 0, y = 0 },
            Size = { Width = 50, Height = 516 }} end, OnInteract = function() SwipeScene("Boot", "Down") end } 
        }
    },
    Test2 ={
        -- { Elder = "data/Scripts/elder.lua" },

        --[[
        { Elder = {
                enabled = false,

                OnConstruct = function()
                    print("called elder.OnConstruct")

                    return {
                        NameId = "Elder",
                        Visible = true,
                        Position = { x = 250, y = 150 },
                        Textures = {
                            { Mirror = "data/Scenes/Intro/RearMirror2.png" }
                        },
                        CurrentImage = "Mirror"
                    }
                end,

                OnInteract = function()
                    if Elder.enabled == true then
                        print("called elder.OnInteract")
                    else
                        print("ENABLE ELDER PLEASE")
                    end
                end
            }
        },
        ]]

        { John = "data/Scripts/john.lua" }
    }
}



-- Set here the first scene to Initialize
--Scenes.StartScene = "Intro"
--Scenes.StartScene = "Boot"
Scenes.StartScene = "GuestRoom"

-- Set here a top access scene to have shared access
Scenes.SharedScene = "Global"
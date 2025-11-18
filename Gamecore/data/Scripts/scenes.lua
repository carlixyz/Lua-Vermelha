
Scenes = {
    Boot = true,
    Road = {
        -- 920 - 516
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

        { 
            Quad = (function() 
                local self = {}
                function self.OnConstruct() 
                    return { NameId = "Rear mirror", Position = { x = 90, y = 60 }, Size = { Width = 150, Height = 100 }, Active = false }
                end
                function self.OnInteractComment() Say("I don't need to thouch the mirror\n it's fine as it is", 4.0) Say() end
                function self.OnLookComment() Say("I can see my face and it needs a break", 4.0) Say() end
                function self.OnInteract() StartSequence(self.OnInteractComment) end function self.OnLook() StartSequence(self.OnLookComment) end
                return self
            end)()
        }, -- REAR MIRROR

        { 
            Quad = (function()  
                local self = { ClickedOnce = false }
                function self.OnConstruct()
                    return { NameId = "Door entry", Position = { x = 600, y = 100 }, Size = { Width = 200, Height = 280 }, Active = false }
                end
                function self.OnCommentLook() Say("Looks like they forgot to lock the door\n and perhaps the wind opened it.", 5.0) Say() end
                function self.OnLook() StartSequence(self.OnCommentLook) end
                function self.OnCommentEnter() Say("rain just stopped, I guess now is the right time\n to leave the car and walk there", 5.0) Say() end
                function self.OnInteract()
                    if self.ClickedOnce then 
                        SetVisible("IntroWolf") Shake("IntroWolf", 64.0, 2.0); Schedule(1.0, "Fade", "Black", 1.0, 1.0) SetVisible("Seventh")
                        SetActive("Rear mirror", false) SetActive("Fachade", false) SetActive("Door entry", false) Schedule(1.0, "Fade", "Panel", 0.0, 100.0)
                        Schedule(3.0, "Fade", "Seventh", 1.0, 60.0) Schedule(2.5, "Move", "Seventh", 0, -220, 220.0) 
                    else
                        self.ClickedOnce = true
                        StartSequence(self.OnCommentEnter) 
                    end
                end 
                return self -- DOOR ENTRY 
            end)() 
        }, -- DOOR ENTRY
        
        { 
            Quad = (function() 
                local self = {}
                function self.OnConstruct() 
                    return { NameId = "Fachade", Position = { x = 300, y = 100 }, Size = { Width = 300, Height = 280 }, Active = false }
                end
                function self.OnCommentEntry() Say("That door looks to be closed \n I should go to the open one instead", 5.0) Say() end
                function self.OnCommentLook() Say("Wow, This people seems to have money, \n maybe there's someone inside", 5.0) Say() end
                function self.OnInteract() StartSequence(self.OnCommentEntry) end function self.OnLook() StartSequence(self.OnCommentLook) end 
                return self
            end)()
        }, -- FACHADE

        { Entity = "IntroWolf", Position = { x = -194, y = -206 }, Textures = "data/Scenes/Intro/IntroWolf.jpg", Visible = false  },
        { Entity = "Black", Textures = { Black = "data/Images/Dark.png"} },
        { Entity = "JumpScare", Textures = "data/Scenes/Intro/JumpScare.jpg", Visible = false  },
        { Entity = "Seventh", Position = { x = -100, y = -220 }, Textures = "data/Scenes/Intro/SeventhFractal.png", Visible = false, Alpha = 0.0  },
    },

    Global = {
        --{ Entity = "Shade", Textures = "data/Images/t.png", Alpha = 1.0, Position = { x = 0, y = 316 }, Visible = false },
        { Entity = "Dark", Textures = { Dark = "data/Images/Dark.png"}, Visible = false, Alpha = 1.0  }

        --{ Dark = { OnConstruct = function() return { NameId = "Dark", Visible = false, Active = false, Clickable = false,
        --          Alpha = 1.0, Textures = { { Dark = "data/Images/Dark.png" } }, CurrentImage = "Dark" } end } }
        --{ John = "data/Scripts/john.lua" }
    }, 
    "Title",
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
Scenes.StartScene = "Boot"
--Scenes.StartScene = "Road"

-- Set here a top access scene to have shared access
Scenes.SharedScene = "Global"
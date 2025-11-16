
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
        { Entity = "Black", Textures = { Black = "data/Images/Dark.png"} },
        { Entity = "JumpScare", Textures = "data/Scenes/Intro/JumpScare.jpg", Visible = false  },

        { 
            Quad = (function() 
                local self = {}
                function self.OnConstruct() 
                    return { NameId = "Rear mirror", Position = { x = 90, y = 60 }, Size = { Width = 150, Height = 100 }, Active = false }
                end
                function self.OnInteractComment() Say("I don't need to thouch the mirror\n it's fine as it is", 4.0) end
                function self.OnLookComment() Say("I can see my face and it needs a break", 4.0) end
                function self.OnInteract() StartSequence(self.OnInteractComment) end function self.OnLook() StartSequence(self.OnLookComment) end
                return self
            end)()
        },

        { 
            Quad = (function()  
                local self = {}
                function self.OnConstruct()
                    return { NameId = "Door entry", Position = { x = 600, y = 100 }, Size = { Width = 200, Height = 280 }, Active = false }
                end
                function self.OnCommentIntro() Say("Looks like they forgot to close the door, \n maybe there's someone inside", 5.0) end
                function self.OnInteract() StartSequence(self.OnCommentIntro) end function self.OnLook() StartSequence(self.OnCommentIntro) end
                return self
            end)()
        },

        
        { 
            Quad = (function() 
                local self = {}
                function self.OnConstruct()
                    return { NameId = "Fachade", Position = { x = 300, y = 100 }, Size = { Width = 300, Height = 280 }, Active = false }
                end
                function self.OnCommentIntro() Say("This people seems to have money, \n maybe there's someone inside", 5.0) end
                function self.OnInteract() StartSequence(self.OnCommentIntro) end function self.OnLook() StartSequence(self.OnCommentIntro) end 
                return self
            end)()
        }

        --{ Entity = "Shade", Textures = "data/Images/t.png" , Alpha = 1.0, Position = { x = 0, y = 316 }, Visible = true  }
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
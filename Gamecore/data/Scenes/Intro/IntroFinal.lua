return {

    { Entity = "IntroLobby", Position = { x = -1, y = -1 }, Textures = {
        { I1 = "data/Scenes/Intro/LobbyIntroLight.jpg" },
        { I2 = "data/Scenes/Intro/LobbyIntroDark.jpg" },
        { I3 = "data/Scenes/Intro/LobbyIntroThunder.jpg" }
    }},

    { Entity = "ElectricBoard", Position = { x = 670, y = 90 }, Textures = "data/Scenes/Intro/PowerPanel.jpg", Visible = false },
    { Entity = "IntroWolf", Position = { x = -194, y = -206 }, Textures = "data/Scenes/Intro/IntroWolf.jpg", Visible = false },
    { Entity = "Seventh", Position = { x = -100, y = -220 }, Textures = "data/Scenes/Intro/SeventhFractal.png", Visible = false, Alpha = 0.0 },

    { Quad = (function()
            local self = {}

            function self.OnConstruct()
                return {
                    NameId = "IntroLeftSide",
                    NameView = "Left\nSide",
                    Position = { x = 0, y = 0 },
                    Size = { Width = 60, Height = 516 },
                    Clickable = false
                }
            end

            function self.OnInteract()
                Move("IntroLobby", 0)
                SetClickable("IntroLeftSide", false)
                SetClickable("IntroRightSide")
                SetClickable("Clock", false)
                SetClickable("IntroRightWindows", false)
                SetClickable("IntroTable", false)
                SetClickable("IntroPowerBoard", false)
                SetClickable("IntroBackDoor")
                SetClickable("Piano")
                SetClickable("IntroSmallTable")
                SetClickable("IntroLeftWindows")
            end

            return self
        end)()
    }, -- LEFT SIDE

    {
        Quad = (function()
            local self = {}

            function self.OnConstruct()
                return {
                    NameId = "IntroLeftWindows", NameView = "Left Windows",
                    Position = { x = 80, y = 80 },
                    Size = { Width = 400, Height = 150 },
                    Active = true
                }
            end

            function self.OnComment()
                Say("Rain stopped a bit,\nbut the sky is still rumbling.", 5.0)
                Say()
            end

            function self.OnInteract() StartSequence(self.OnComment) end
            function self.OnLook() StartSequence(self.OnComment) end

            return self
        end)()
    }, -- Left windows

    {
        Quad = (function()
            local self = {}

            function self.OnConstruct()
                return {
                    NameId = "IntroSmallTable", NameView = "Small Table",
                    Position = { x = 210, y = 260 },
                    Size = { Width = 130, Height = 90 },
                    Active = true
                }
            end

            function self.OnCommentEntry()
                Say("A small table with a decoration bowl and some books\nCan't read nothing'", 6.0)
                Say()
            end

            function self.OnInteract() StartSequence(self.OnCommentEntry) end
            function self.OnLook() StartSequence(self.OnCommentEntry) end

            return self
        end)()
    }, -- Small Table

    {
        Quad = (function()
            local self = {}

            function self.OnConstruct()
                return {
                    NameId = "IntroBackDoor", NameView = "Back Door",
                    Position = { x = 655, y = 114 },
                    Size = { Width = 55, Height = 120 },
                    Active = true
                }
            end

            function self.OnCommentEntry()
                Say("There's a door there but is closed \nand I don't see a key anywhere", 5.0)
                Say()
            end

            function self.OnInteract() StartSequence(self.OnCommentEntry) end
            function self.OnLook() StartSequence(self.OnCommentEntry) end

            return self
        end)()
    }, -- Back Door

    {
        Quad = (function()
            local self = {}

            function self.OnConstruct()
                return {
                    NameId = "Piano",
                    Position = { x = 520, y = 180 },
                    Size = { Width = 80, Height = 60 },
                    Active = true
                }
            end

            function self.OnComment()
                Say("I think there's a piano in the other side of the room", 5.0)
                Say("I'm not going to touch that", 3.0)
                Say()
            end

            function self.OnInteract() StartSequence(self.OnComment) end
            function self.OnLook() StartSequence(self.OnComment) end

            return self
        end)()
    }, -- Piano

    {
        Quad = (function()
            local self = {}

            function self.OnConstruct()
                return {
                    NameId = "IntroRightSide", NameView = "Right\nSide",
                    Position = { x = 840, y = 0 },
                    Size = { Width = 80, Height = 516 },
                    Clickable = true
                }
            end

            function self.OnInteract()
                Move("IntroLobby", -604)
                SetClickable("IntroLeftSide")
                SetClickable("IntroRightSide", false)
                SetClickable("Clock", true)
                SetClickable("IntroRightWindows", true)
                SetClickable("IntroTable", true)
                SetClickable("IntroPowerBoard", true)
                SetClickable("IntroBackDoor", false)
                SetClickable("Piano", false)
                SetClickable("IntroSmallTable", false)
                SetClickable("IntroLeftWindows", false)
            end

            return self
        end)()
    }, -- RIGHT SIDE

    {
        Quad = (function()
            local self = {}

            function self.OnConstruct()
                return {
                    NameId = "IntroRightWindows", NameView = "Right Windows",
                    Position = { x = 360, y = 96 },
                    Size = { Width = 410, Height = 150 },
                    Clickable = false
                }
            end

            function self.OnComment()
                Say("Between flashes of light, I can glimpse some trees\nswaying in the darkness of the night...", 6.0)
                Say()
            end

            function self.OnInteract() StartSequence(self.OnComment) end
            function self.OnLook() StartSequence(self.OnComment) end

            return self
        end)()
    }, -- Right windows

    {
        Quad = (function()
            local self = {}

            function self.OnConstruct()
                return {
                    NameId = "Clock",
                    Position = { x = 280, y = 130 },
                    Size = { Width = 20, Height = 100 },
                    Clickable = false
                }
            end

            function self.OnCommentEntry()
                Say("Something is ticking there..\nI guess We're safe for now", 6.0)
                Say()
            end

            function self.OnInteract() StartSequence(self.OnCommentEntry) end
            function self.OnLook() StartSequence(self.OnCommentEntry) end

            return self
        end)()
    }, -- CLOCK

    {
        Quad = (function()
            local self = {}

            function self.OnConstruct()
                return {
                    NameId = "IntroTable",
                    NameView = "Table",
                    Position = { x = 310, y = 260 },
                    Size = { Width = 160, Height = 60 },
                    Clickable = false
                }
            end

            function self.OnCommentEntry()
                Say("There's a cup of wine and something slimey\nI can't see nothing really", 6.0)
                Say()
            end

            function self.OnInteract() StartSequence(self.OnCommentEntry) end
            function self.OnLook() StartSequence(self.OnCommentEntry) end

            return self
        end)()
    }, -- Table

    {
        Quad = (function()
            local self = {
                ClickedOnce = false,
                ClickedTwice = false,
                Timer = 16.0,
                ThunderCancelID = 0
            }

            function AlternateThunders()
                self.Timer = self.Timer - 1.0
                if self.Timer <= 0.0 then
                    self.Timer = 8.0
                    Schedule(1.0, "SetState", "IntroLobby", "I3")
                    Schedule(1.2, "SetState", "IntroLobby", "I2")
                    ---Schedule(1.5, "PlaySound", "Thunder")

                    Schedule(1.4, "SetState", "IntroLobby", "I3")
                    Schedule(1.6, "SetState", "IntroLobby", "I2")

                    Schedule(1.8, "SetState", "IntroLobby", "I3")
                    Schedule(2.0, "SetState", "IntroLobby", "I2")
                    ---Schedule(2.0, "PlaySound", "Thunder")

                    Schedule(3, "TriggerThunder", 2)
                end
            end

            function self.OnConstruct()
                return {
                    NameId = "IntroPowerBoard",
                    NameView = "Power\nBoard",
                    Position = { x = 820, y = 150 },
                    Size = { Width = 70, Height = 70 },
                    Clickable = false
                }
            end

            function self.OnScreenInput()
                if self.ClickedOnce == false then
                    self.ThunderCancelID = ScheduleRepeat(1, "AlternateThunders", "ThunderCancelID")
                    self.ClickedOnce = true
                    SetState("IntroLobby", "I2")
                    StartSequence(self.OnLightsOut)
                    Schedule(3, "TriggerThunder", 2)
                end
            end

            function self.OnLightsOut()
                Say("Damn, what just happened?", 3.0)
                Say("I can't see a thing!", 3.0)
                Say()
            end

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

                    SetClickable("IntroLeftSide", false)
                    SetClickable("IntroPowerBoard", false)
                    SetClickable("IntroTable", false)
                    SetClickable("IntroRightWindows", false)
                    SetClickable("Clock", false)

                    Schedule(4.0, "SetVisible", "IntroWolf")
                    Schedule(4.0, "Shake", "IntroWolf", 64.0, 2.0)
                    Schedule(4.5, "SetVisible", "Dark")
                    Schedule(4.5, "Fade", "Dark", 1.0, 1.0)
                    Schedule(6.0, "SetVisible", "IntroLobby", false)
                    Schedule(6.0, "SetVisible", "IntroWolf", false)

                    --Schedule(8.0, "SetAlpha", "Dark", 1.0)
                    --Schedule(7.0, "SetVisible", "IntroWolf", false)
                    Schedule(8.0, "Fade", "Dark", 1.0, 0.5)

                    Schedule(8.8, "BlendScene", "Title")

                end
            end

            function self.OnInteract() StartSequence(self.OnBoardEntry) end
            function self.OnLook() StartSequence(self.OnBoardEntry) end

            return self
        end)()
    }, -- ELECTRIC BOARD
}
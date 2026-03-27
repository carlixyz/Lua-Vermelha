return {
    { Entity = "GuestRoom", Textures = { GuestRoom = "data/Scenes/Mansion/RoomGuest.jpg"} },
    { Entity = "AerialView", Textures = { AerialView = "data/Scenes/Mansion/GeneralViewpoint.jpg"}, Visible = false },
    --{ Entity = "IntroWakeup", Textures = { { IW1 = "data/Scenes/Mansion/WakeEyes.jpg"}, {IW2 = "data/Scenes/Mansion/WakeUp.jpg"} } },

    { IntroWakeUp = (function() 
            local self = { Painted = false }
            function self.OnConstruct() return { NameId = "IntroWakeup", Clickable = false,
            Textures = { { IW1 = "data/Scenes/Mansion/WakeEyes.jpg"}, {IW2 = "data/Scenes/Mansion/WakeUp.jpg"} }, --CurrentImage = "WakeEyes" 
        }
        end

        function self.OnInit()

            SetAlpha("Dark", 1.0)
            SetVisible("Dark", true)

            SetAlpha("Shade", 0)
            SetVisible("Shade", true)

            SetThunder(true)
            --SetNoise(false)

            Schedule( 4, "TriggerThunder", 2)
            Schedule( 5, "Fade", "Dark", 0.0, 1.0)

            Schedule( 6.5, "TriggerThunder", 3)
            Schedule( 7, "SetState", "IntroWakeup", "IW2")
            Schedule( 7, "SetNoise", false)

            --print("Title =", Title)
            --print("type(Title) =", type(Title))
            --assert(type(Title) == "function", "Title is not a function!")
            --ShowTitle("FIRST GUEST", 7, 64.0,  320, 140, 255, 255, 255, 64)
            
            Schedule( 8.0, "Fade", "IntroWakeup", 0.0, 10.0)
            Schedule( 8.1, "ShowTitle", "FIRST GUEST", 7, 64.0,  320, 140, 255, 255, 255, 64)

            Schedule( 15.0, "SetThunder", false)
            Schedule( 16.0, "SetInventory", true)

            --Schedule( 15.0, "Fade", "Shade", 0.45, 4)
            SetShadeAlpha( 0 )          -- Use custom Shade
            print() print() print("CALLED IntroWakeup.OnInit") print() print()
        end

        function self.OnExit()
            -- SetAlpha("Shade", 0.0)      -- 
            Fade("Shade", 0.0, 0.3)
            SetShadeAlpha( 0.35 )       -- Enable auto shade
        end

        return self
        end)()    
    },
    
    
    { Quad = (function() 
            local self = {}
            function self.OnConstruct() return { NameId = "Tapiz", NameView = "Tapestry", Pos = { x = 45, y = 80 }, Size = { Width = 160, Height = 280 }} end
            --function self.OnCommentEntry() Say("/nCacho", "I don't want to touch that\n It's full of dust", 4.0) Say() end
            function self.OnCommentEntry() Say("\n\nI don't want to touch that\n It's full of dust", 4.0) Say() end
            function self.OnCommentLook() Say("\n\nIt's just a room decoration", 3.0) Say() end
            function self.OnInteract() StartSequence(self.OnCommentEntry) end function self.OnLook() StartSequence(self.OnCommentLook) end 
            return self
        end)()
    }, -- TAPIZ

    { Quad = (function() 
            local self = {}
            function self.OnConstruct() return { NameId = "vestidor", NameView = "Dresser", Pos = { x = 284, y = 232 }, Size = { Width = 70, Height = 105 }} end
            function self.OnCommentEntry() Say("\n\nNothing of importance here", 3.0) Say() end
            function self.OnCommentLook() Say("\n\njust an empty dresser", 3.0) Say() end
            function self.OnInteract() StartSequence(self.OnCommentEntry) end function self.OnLook() StartSequence(self.OnCommentLook) end 
            return self
        end)()
    },  -- DRESSER

    { Quad = (function() 
            local self = {}
            function self.OnConstruct() return { NameId = "GuestBed",  NameView = "Bed", Pos = { x = 405, y = 226 }, Size = { Width = 158, Height = 143 }} end
            function self.OnCommentEntry() Say("\n\nI've rested enough.", 3.0) Say() end
            function self.OnCommentLook() Say("\n\njust a normal bed", 3.0) Say() end
            function self.OnInteract() StartSequence(self.OnCommentEntry) end function self.OnLook() StartSequence(self.OnCommentLook) end 
            return self
        end)()
    },  -- BED

    { Quad = (function() 
            local self = {}
            function self.OnConstruct() return { NameId = "PaintA", NameId = "Floresta\npaint", Pos = { x = 760, y = 107 }, Size = { Width = 148, Height = 138 }} end
            function self.OnCommentEntry() Say("\n\nNothing to do with that", 3.0) Say() end
            function self.OnCommentLook() Say("\n\nA painting of the mato grosso", 3.0) Say() end
            function self.OnInteract() StartSequence(self.OnCommentEntry) end function self.OnLook() StartSequence(self.OnCommentLook) end 
            return self
        end)()
    },  -- PAINTING

    { Quad = (function() 
            local self = {}
            function self.OnConstruct() 
                return { NameId = "HideDoorA", NameView = "Hidden Door", Position = { x = 90, y = 360 }, Size = { Width = 100, Height = 85 } }
            end
            function self.OnInteractComment() Say("\n\nSeems it's locked from the other side", 3.0) Say() end
            function self.OnLookComment() Say("\n\nOhh there's a hidden door behind the tapestry", 4.0) Say() end
            function self.OnInteract() StartSequence(self.OnInteractComment) end function self.OnLook() StartSequence(self.OnLookComment) end
            return self
        end)()
    }, -- SECRET DOOR

    { Quad = (function() 
        local self = {}
        function self.OnConstruct() return { NameId = "GuestExit", NameView = "Exit",
        Pos = { x = 200, y = 400 }, Size = { Width = 560, Height = 110 }} end
        -- Pos = { x = 0, y = 445 }, Size = { Width = 920, Height = 70 }} end
        function self.OnCommentLook() Say("\n\nBehind me there's the room exit", 3.0) Say() end
        function self.OnInteract() BlendScene("Hallway") end function self.OnLook() StartSequence(self.OnCommentLook) end 
        return self
        end)() 
    } -- EXIT DOOR

}
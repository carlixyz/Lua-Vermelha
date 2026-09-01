return {

    { Entity = "TreeFar", Visible = true, Textures =
        { { WinFarReg = "data/Scenes/Mansion/WindowFarReg.jpg" }, 
        { WinFarEmpty = "data/Scenes/Mansion/WindowFar.jpg" } }
    }, -- Window tree far

    { Entity = "TreeCloseup", Visible = false, Textures =
        { { WinReg = "data/Scenes/Mansion/WindowCloseRegina.jpg" }, 
        { WinEmpty = "data/Scenes/Mansion/WindowClose.jpg" } }
    }, -- Window tree close

    { Entity = "History", Textures = "data/Scenes/Psycho/Navajo.jpg", Visible = false},

    { Entity = "QuickPhotoEvil", Textures = "data/Scenes/Mansion/FamilyPhotoAll.jpg", Visible = false},

    { Entity = "EvilSight", Textures = "data/Scenes/Ending/MorphC.jpg", Visible = false},

    { Entity = "DarkPathComing", Textures = "data/Scenes/Parking/TownPathBNight.jpg", Visible = false},
    
    { Entity = "BrainEye", Textures = "data/Scenes/Psycho/EyeXL.jpg", Visible = false},

    --{ Entity = "RoadRecall", Textures = "data/Scenes/Intro/JumpScare.jpg", Visible = false},

    { Quad = (function() local self = { FoundAlready = false }
        function self.OnConstruct() 
            return { NameId = "TreeShadow", NameView = "??", Pos = { x = 145, y = 310 }, Size = { Width = 50, Height = 110 } } 
        end

        function self.OnDone()
            SetVisible("TreeCloseup", true)
            Wait(false)
            SetVisible("TreeCloseup", false)
        end

        function self.OnCloseup()
            self.FoundAlready = true

            SetNoise(true)
            Scale("TreeCloseup", 1.3, 150)
            SetVisible("TreeCloseup", true)
            Wait(false)

            SetVisible("History")
            Wait(0.1, false)

            SetVisible("QuickPhotoEvil")
            Wait(0.1, false)

            SetVisible("EvilSight")
            Wait(0.1, false)
            
            SetVisible("DarkPathComing")
            Wait(0.1, false)

            Scale("BrainEye", 1.2, 150)
            SetVisible("BrainEye")
            Wait(0.1, false)
            Scale("WindowOutside", 1.2, 1)
            SetNoise(false)

            SetVisible("TreeWind")
            TreeWind.StartAnimation()
            SetVisible("Birds")
            Birds.StartAnimation()
            Wait(false)

            Scale("WindowOutside", 1.0, 100)
            SetVisible("WindowOutside")
            TreeWind.StopAnimation()
            Birds.StopAnimation()
            Wait(false)

            SetState("TreeFar", "WinFarEmpty")
            SetState("TreeCloseup", "WinEmpty")
            Scale("TreeCloseup", 1, 0.1)
            SetVisible("Birds", false)
            SetVisible("TreeWind", false)

            SetVisible("History", false)
            SetVisible("EvilSight", false)
            SetVisible("QuickPhotoEvil", false)
            SetVisible("DarkPathComing", false)
            SetVisible("BrainEye", false)
            SetVisible("TreeCloseup", false)

            Fade("WindowOutside", 0.0)
            Wait(false)
        end
        function self.OnInteract()
            if not self.FoundAlready then
                PlayMusic("Creepy", false)
                StartSequence(self.OnCloseup) 
            else
                StartSequence(self.OnDone) 
            end
        end 
                
        function self.OnCommentLook()
            if self.FoundAlready then
                Say("\nSomething weird is going on..", 3.0) Say()
            else
                Say("\nI think there's something over there..", 3.0) Say()
            end
        end

        function self.OnLook() StartSequence(self.OnCommentLook) 
        end

        return self
        end)()
    },  -- TreeShadow

    { Quad = { OnConstruct = function() return { NameId = "SideExitWindowTree", Cursor = "MRight", Pos = { x = 840, y = 0 }, 
        Size = { Width = 100, Height = 420 }} end, OnInteract = function() IntroWakeup.FirstTime = false SwipeScene("GuestRoom", "Down") end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "ExitWindowTree", Cursor = "MDown", Pos = { x = 0, y = 420 }, 
        Size = { Width = 920, Height = 90 }} end, OnInteract = function() IntroWakeup.FirstTime = false SwipeScene("GuestRoom", "Up") end } 
    },

    { TreeWind = (function()
        local self = {
            AnimTask = 0,
            AnimFrameIds = {},
            CurrentFrame = 1,
            TimeBetweenFrames = 0.05,    
            TotalFrames = 32
        }
        function self.OnConstruct()
        return { 
            Visible = false, 
            Clickable = false, 
            Textures = { 
                { TW00 = "data/Intro/TreeWind/frame_00.jpg"}, 
                { TW01 = "data/Intro/TreeWind/frame_01.jpg"}, 
                { TW02 = "data/Intro/TreeWind/frame_02.jpg"}, 
                { TW03 = "data/Intro/TreeWind/frame_03.jpg"}, 
                { TW04 = "data/Intro/TreeWind/frame_04.jpg"}, 
                { TW05 = "data/Intro/TreeWind/frame_05.jpg"}, 
                { TW06 = "data/Intro/TreeWind/frame_06.jpg"}, 
                { TW07 = "data/Intro/TreeWind/frame_07.jpg"}, 
                { TW08 = "data/Intro/TreeWind/frame_08.jpg"}, 
                { TW09 = "data/Intro/TreeWind/frame_09.jpg"}, 
                { TW10 = "data/Intro/TreeWind/frame_10.jpg"}, 
                { TW11 = "data/Intro/TreeWind/frame_11.jpg"}, 
                { TW12 = "data/Intro/TreeWind/frame_12.jpg"}, 
                { TW13 = "data/Intro/TreeWind/frame_13.jpg"}, 
                { TW14 = "data/Intro/TreeWind/frame_14.jpg"}, 
                { TW15 = "data/Intro/TreeWind/frame_15.jpg"}, 
                { TW16 = "data/Intro/TreeWind/frame_16.jpg"}, 
                { TW17 = "data/Intro/TreeWind/frame_17.jpg"}, 
                { TW18 = "data/Intro/TreeWind/frame_18.jpg"}, 
                { TW19 = "data/Intro/TreeWind/frame_19.jpg"}, 
                { TW20 = "data/Intro/TreeWind/frame_20.jpg"}, 
                { TW21 = "data/Intro/TreeWind/frame_21.jpg"}, 
                { TW22 = "data/Intro/TreeWind/frame_22.jpg"}, 
                { TW23 = "data/Intro/TreeWind/frame_23.jpg"}, 
                { TW24 = "data/Intro/TreeWind/frame_24.jpg"}, 
                { TW25 = "data/Intro/TreeWind/frame_25.jpg"}, 
                { TW26 = "data/Intro/TreeWind/frame_26.jpg"}, 
                { TW27 = "data/Intro/TreeWind/frame_27.jpg"}, 
                { TW28 = "data/Intro/TreeWind/frame_28.jpg"}, 
                { TW29 = "data/Intro/TreeWind/frame_29.jpg"}, 
                { TW30 = "data/Intro/TreeWind/frame_30.jpg"}, 
                { TW31 = "data/Intro/TreeWind/frame_31.jpg"}
            } 
        }
        end

        function self.OnInit()
            self.OnEnter()
        end

        function self.OnEnter()

            self.AnimFrameIds = GetEntityTextureIDs("TreeWind")
            self.TotalFrames = #self.AnimFrameIds
            print(#self.AnimFrameIds)

            --self.StartAnimation()
        end

        function self.StartAnimation()
            if self.AnimTask == 0 then
               self.AnimTask = ScheduleRepeat(self.TimeBetweenFrames, "OnTreeAnimation", "CancelTreeAnim")
            end
        end

        function OnTreeAnimation()
            
            if GetVisible("TreeWind") then
                SetState( "TreeWind", self.AnimFrameIds[self.CurrentFrame])
            end
            --print(self.AnimFrameIds[self.CurrentFrame])

            self.CurrentFrame = self.CurrentFrame + 1
            
            if self.CurrentFrame > self.TotalFrames then
                self.CurrentFrame = 1
            end
        end

        function self.OnExit()
            self.StopAnimation()
        end

        function self.StopAnimation()
            if self.AnimTask ~= 0 then
                CancelScheduled(self.AnimTask)
                self.AnimTask = 0
            end
        end

        return self
        end)() 
    }, -- TreeWind

    { Birds = (function()
        local self = {
            AnimTask = 0,
            AnimFrameIds = {},
            CurrentFrame = 1,    
            TimeBetweenFrames = 0.1,    
            TotalFrames = 37
        }
        function self.OnConstruct()
        return { 
            Visible = false, 
            Clickable = false, 
            Textures = { 
                { B00 = "data/Intro/Birds/birds-00.png"}, 
                { B01 = "data/Intro/Birds/birds-01.png"}, 
                { B02 = "data/Intro/Birds/birds-02.png"}, 
                { B03 = "data/Intro/Birds/birds-03.png"}, 
                { B04 = "data/Intro/Birds/birds-04.png"}, 
                { B05 = "data/Intro/Birds/birds-05.png"}, 
                { B06 = "data/Intro/Birds/birds-06.png"}, 
                { B07 = "data/Intro/Birds/birds-07.png"}, 
                { B08 = "data/Intro/Birds/birds-08.png"}, 
                { B09 = "data/Intro/Birds/birds-09.png"}, 
                { B10 = "data/Intro/Birds/birds-10.png"}, 
                { B11 = "data/Intro/Birds/birds-11.png"}, 
                { B12 = "data/Intro/Birds/birds-12.png"}, 
                { B13 = "data/Intro/Birds/birds-13.png"}, 
                { B14 = "data/Intro/Birds/birds-14.png"}, 
                { B15 = "data/Intro/Birds/birds-15.png"}, 
                { B16 = "data/Intro/Birds/birds-16.png"}, 
                { B17 = "data/Intro/Birds/birds-17.png"}, 
                { B18 = "data/Intro/Birds/birds-18.png"}, 
                { B19 = "data/Intro/Birds/birds-19.png"}, 
                { B20 = "data/Intro/Birds/birds-20.png"}, 
                { B21 = "data/Intro/Birds/birds-21.png"}, 
                { B22 = "data/Intro/Birds/birds-22.png"}, 
                { B23 = "data/Intro/Birds/birds-23.png"}, 
                { B24 = "data/Intro/Birds/birds-24.png"}, 
                { B25 = "data/Intro/Birds/birds-25.png"}, 
                { B26 = "data/Intro/Birds/birds-26.png"},
                { B27 = "data/Intro/Birds/birds-27.png"},
                { B28 = "data/Intro/Birds/birds-28.png"},
                { B29 = "data/Intro/Birds/birds-29.png"},
                { B30 = "data/Intro/Birds/birds-30.png"},
                { B31 = "data/Intro/Birds/birds-31.png"},
                { B32 = "data/Intro/Birds/birds-32.png"},
                { B33 = "data/Intro/Birds/birds-33.png"},
                { B34 = "data/Intro/Birds/birds-34.png"},
                { B35 = "data/Intro/Birds/birds-35.png"},
                { B36 = "data/Intro/Birds/birds-36.png"} 
            } 
        }
        end

        function self.OnInit()
            self.OnEnter()
        end

        function self.OnEnter()

            self.AnimFrameIds = GetEntityTextureIDs("Birds")
            self.TotalFrames = #self.AnimFrameIds
            print(#self.AnimFrameIds)


            -- self.StartAnimation()
        end

        function self.StartAnimation()
            if self.AnimTask == 0 then
               self.AnimTask = ScheduleRepeat(self.TimeBetweenFrames, "OnBirdsAnimation", "CancelBirdsAnim")
            end
        end

        function OnBirdsAnimation()
            if GetVisible("Birds") then
                SetState( "Birds", self.AnimFrameIds[self.CurrentFrame])
            end
            --print(self.AnimFrameIds[self.CurrentFrame])

            self.CurrentFrame = self.CurrentFrame + 1
            
            if self.CurrentFrame > self.TotalFrames then
                self.CurrentFrame = 1
            end
        end

        function self.OnExit()
            self.StopAnimation()
        end

        function self.StopAnimation()
            if self.AnimTask ~= 0 then
                CancelScheduled(self.AnimTask)
                self.AnimTask = 0
            end
        end

        return self
        end)() 
    }, -- Birds

    { Entity = "WindowOutside", Textures = "data/Scenes/Mansion/WindowOutside.jpg", Visible = false},

}
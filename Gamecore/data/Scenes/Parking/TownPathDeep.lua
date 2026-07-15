return {
    { Entity = "TownPathDeepBG", Textures = {
        {TownPathDeep = "data/Scenes/Parking/TownPathDeep.jpg"}}
    },

    { Entity = "Goyete", Textures = "data/Scenes/Psycho/Goya.jpg", Visible = false},

    { Entity = "Bitten", Textures = "data/Scenes/Psycho/LegInjury.jpg", Visible = false},

    { Entity = "QuickPhotoDevil", Textures = "data/Scenes/Mansion/FamilyPhotoAll.jpg", Visible = false},

    { Entity = "Luna", Textures = "data/Scenes/Psycho/LuaVermelha.jpg", Visible = false},

    { Entity = "DevilSight", Textures = "data/Scenes/Ending/MorphD.jpg", Visible = false},

    { Entity = "Navajo", Textures = "data/Scenes/Psycho/Navajo.jpg", Visible = false},

    { Entity = "TheEye", Textures = "data/Scenes/Psycho/EyeXL.jpg", Visible = false},

    { Entity = "Christophoro", Textures = "data/Scenes/Psycho/SaintChristopher.jpg", Visible = false},

    { Entity = "RoadRecall", Textures = "data/Scenes/Intro/JumpScare.jpg", Visible = false},

    { Quad = { OnConstruct = function() return { NameId = "Road Path Return", Cursor = "MDown", Pos = { x = 377, y = 395 }, 
        Size = { Width = 370, Height = 115 }} end, OnInteract = function() SwipeScene("TownPath", "Up") end } 
    },


    { Quad = (function() local self = { SawCinematic = false, ComingBack = false }
        function self.OnConstruct() 
            return { NameId = "PathPsycho", NameView = "Woods Path Deep", Cursor = "MUp",
            Pos = { x = 440, y = 140 }, Size = { Width = 160, Height = 180 }} 
        end

        function self.OnDone()
            SwipeScene("TownView", "Up")
        end

        function self.OnSequence()
            self.SawCinematic = true
            
            Scale("TownPathDeepBG", 1.3, 0.2)
            Wait(0.2, false)

            SetVisible("Goyete")
            Wait(0.1, false)

            SetVisible("Bitten")
            Wait(0.1, false)

            SetVisible("QuickPhotoDevil")
            Wait(0.1, false)
            
            SetVisible("Luna")
            Wait(0.1, false)

            SetVisible("DevilSight")
            Wait(0.1, false)

            SetVisible("Navajo")
            Wait(0.1, false)

            SetVisible("TheEye")
            Wait(0.1, false)

            SetVisible("Christophoro")
            Wait(0.1, false)

            SetVisible("RoadRecall")
            Wait(0.1, false)


            --SetNoise(false)


            --Wait(false)

            --SetState("TreeFar", "WinFarEmpty")

            SetVisible("Goyete", false)
            SetVisible("Bitten", false)
            SetVisible("QuickPhotoDevil", false)
            SetVisible("Luna", false)
            SetVisible("DevilSight", false)
            SetVisible("Navajo", false)
            SetVisible("TheEye", false)
            SetVisible("Christophoro", false)
            SetVisible("RoadRecall", false)
            Scale("TownPathDeepBG", 1.0, 50)

            Wait(false)
        end

        function self.OnInteract()
            if not self.SawCinematic then
                StartSequence(self.OnSequence) 
            else
                StartSequence(self.OnDone) 
            end
        end 
                
        function self.OnCommentLook()
            if self.SawCinematic then
                Say("There's something strange about this place.", 4.0) Say()
            else
                Say("So this looks like the town path that Ada told me", 5.0) Say()
            end
        end

        function self.OnLook() StartSequence(self.OnCommentLook) 
        end

        return self
        end)()
    },  -- PathSequence
}
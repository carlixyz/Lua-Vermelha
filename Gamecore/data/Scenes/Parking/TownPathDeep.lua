return {
    { Entity = "TownPathDeepBG", Textures = {
        {TownPathDeep = "data/Scenes/Parking/TownPathDeep.jpg"}}
    },

    { Entity = "PicuNicu", Textures = "data/Scenes/Psycho/Picnic.jpg", Visible = false},

    { Entity = "Bitten", Textures = "data/Scenes/Psycho/LegInjury.jpg", Visible = false},

    { Entity = "QuickPhotoDevil", Textures = "data/Scenes/Mansion/FamilyPhotoAll.jpg", Visible = false},

    { Entity = "Luna", Textures = "data/Scenes/Psycho/LuaVermelha.jpg", Visible = false},

    { Entity = "DevilSight", Textures = "data/Scenes/Ending/MorphD.jpg", Visible = false},

    { Entity = "Navaja", Textures = "data/Scenes/Psycho/Navaja.jpg", Visible = false},

    { Entity = "AnotherEye", Textures = "data/Scenes/Psycho/EyeXL.jpg", Visible = false},

    { Entity = "Christoph", Textures = "data/Scenes/Psycho/SaintChristopher.jpg", Visible = false},

    { Entity = "RoadRecall", Textures = "data/Scenes/Intro/JumpScare.jpg", Visible = false},

    { Quad = { OnConstruct = function() return { NameId = "Road Path Return", Cursor = "MDown", Pos = { x = 377, y = 395 }, 
        Size = { Width = 370, Height = 115 }} end, OnInteract = function() SwipeScene("TownPath", "Up") end } 
    },


    { Quad = (function() local self = { SawCinematic = false, ComingBack = false }
        function self.OnConstruct() 
            return { NameId = "PathPsycho", NameView = "Woods Path Deep", Cursor = "MUp",
            Pos = { x = 440, y = 140 }, Size = { Width = 160, Height = 180 }} 
        end


        function self.OnSequence()
            self.SawCinematic = true
            
            Scale("TownPathDeepBG", 1.3, 0.2)
            Wait(0.2, false)

            SetVisible("PicuNicu")
            Wait(0.1, false)

            SetVisible("Bitten")
            Wait(0.1, false)

            SetVisible("QuickPhotoDevil")
            Wait(0.1, false)
            
            SetVisible("Luna")
            Wait(0.1, false)

            SetVisible("DevilSight")
            Wait(0.1, false)

            SetVisible("Navaja")
            Wait(0.1, false)

            SetVisible("AnotherEye")
            Wait(0.1, false)

            SetVisible("Christoph")
            Wait(0.1, false)

            SetVisible("RoadRecall")
            Wait(0.1, false)

            --SetNoise(false)
            --Wait(false)
            --SetState("TreeFar", "WinFarEmpty")

            Scale("TownPathDeepBG", 1.3, 0)
            SetCurrentScene("TownView")
            Scale("TownViewBG", 1.3, 0)
            Schedule(0.2,"Scale","TownViewBG", "1.0", "50")
            
            SetVisible("PicuNicu", false)
            SetVisible("Bitten", false)
            SetVisible("QuickPhotoDevil", false)
            SetVisible("Luna", false)
            SetVisible("DevilSight", false)
            SetVisible("Navaja", false)
            SetVisible("AnotherEye", false)
            SetVisible("Christoph", false)
            SetVisible("RoadRecall", false)
            Scale("TownPathDeepBG", 1.0, 50)

            Wait(false)
        end

        function self.OnInteract()
            if not self.SawCinematic then
                StartSequence(self.OnSequence)
            else
                SwipeScene("TownView", "Up")
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
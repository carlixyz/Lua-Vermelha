return {

    { Entity = "ThugsFar", Textures = "data/Scenes/Town/ThugsFar.jpg", Visible = true},

    { Entity = "PlazaLamp", Textures = "data/Scenes/Town/PlazaLamp.jpg", Visible = true},

    { Entity = "ThugsNear", Textures = "data/Scenes/Town/ThugsNear.jpg", Alpha = 0.0},

    { Entity = "MolotovSequence", Textures = {
        { MolotovA = "data/Scenes/Town/PlazaMolotovA.jpg"},
        { MolotovB = "data/Scenes/Town/PlazaMolotovB.jpg"},
        { MolotovC = "data/Scenes/Town/PlazaMolotovC.jpg"} },
        Visible = false},

    { Entity = "ThugsRunning", Textures = "data/Scenes/Town/PlazaMolotovD.jpg", Alpha = 0.0},

    { Quad = (function() local self = { IntroDone = false}
        function self.OnConstruct()
            return { NameId = "Suspicious violence", Pos = { x = 345, y = 80 }, Size = { Width = 400, Height = 320 } } 
        end
        function self.OnInit()
            self.OnEnter()
        end

        function self.OnEnter()
            StartSequence(self.OnIntroLamp)
        end

        function self.OnIntroLamp()
            SetNoise(true)
            Scale("PlazaLamp", 1.3, 0)
            Wait(false, 0.1)
            Scale("PlazaLamp", 1.0, 100)

            Schedule(4, "Fade", "PlazaLamp", 0, 3)
            Schedule(4, "Scale", "ThugsFar", 1.5, 250)

            Wait(false, 6)
            Say("Help me!", 1)
            Say("Thiago", "Something's going on, I'd better stay here", 3)
            Say("Help..", 2)

            Schedule(10, "ForceThugsCinematic")
        end
        
        function self.OnLookComment()
            if IntroDone then
                Say("Oh no, I need a distraction right now", 4.0) Say()
            else
                Say("Something bad is happening there", 4.0) Say()
            end
        end
        function self.OnLook() StartSequence(self.OnLookComment) end

        function self.OnInteract()
            if not IntroDone then
                IntroDone = true
                StartSequence(self.OnCinematic)
            else
                StartSequence(function() Say("No way, I'm not going there", 3.0) Say("We're outnumbered, They'll kill us", 3.0) end) 
            end
        end
        
        function ForceThugsCinematic()
            if not IntroDone then
                self.OnInteract()
            end
        end

        function self.OnCinematic()
            SetClickable("Suspicious violence", false) -- 
            Shake("ThugsNear", 20.0, 5)
            Fade("ThugsNear", 1.0)
            Say("Ahhh please stop, I can't breathhh...", 3)
            Scale("ThugsNear", 1.4, 350)     --

            Say("You should know your boundaries scumbag...", 3)
            Say("Your tongue loosens with alcohol\nand you end up saying too much bullshit..", 5)
            Say("Next time you'll think twice before opening the mouth", 4)
            Shake("ThugsNear", 12.0, 5)

            Say("Thiago","Jeez, this is brutal", 3)
            Say("Thiago","I've to stop it", 2)
            Say("Thiago","But can't fight with them, I'm outnumbered", 4)

            Say("...", 1)
            Shake("ThugsNear", 6.0, 5)
            Say("Viktor hold on, I'm affraid there won't be a next time..", 4)
            Say("Viktor","Oh really? sue me, I don't give a fuck haha!", 4)
            Say("Come on, let's go, the police is roaming around..", 4)

            Wait(1, true)

            SetClickable("Trash Can", true) -- 
            Schedule(5, "SetClickable", "Suspicious violence", true)
            Scale("ThugsFar", 1.0, 100)     --
            Fade("ThugsNear", 0.0)

            Say("Thiago","Must do something right now", 3)
            Say("Thiago","Maybe I can create a firework or diversion", 4)
            Say("Thiago","Something to distract them..", 5)
        end

        return self
        end)() 
    },  -- THUGS LOGIC


    { Quad = (function() 
        local self = {}
        function self.OnConstruct() return { NameId = "Trash Can", Clickable = false,
            Pos = { x = 365, y = 275 }, Size = { Width = 80, Height = 128 }} end
        
        function self.OnInit()                      -- JUST FOR TESTING DISABLE AFTER USE
            if not DrunkMan.Sleeping and not IsEntityInScene("Alcohol", "Inventory") then
                PickUp("MolotovFire") 
            end 
        end                       

        function self.OnCommentEntry() Say("I'm not going closer, they'll see me", 3.0) Say() end
        function self.OnCommentLook() Say("Maybe I can do something with that trash can", 3.0) Say() end
        function self.OnInteract() StartSequence(self.OnCommentEntry) end function self.OnLook() StartSequence(self.OnCommentLook) end 
        function self.OnEndSequence()
            Scale("MolotovSequence", 1.4, 50)     --
            SetVisible("MolotovSequence", true)
            Wait(.05, false)
            SetVisible("MolotovSequence", false)
            Wait(.05, false)
            SetVisible("MolotovSequence", true)
            Wait(.05, false)
            SetVisible("MolotovSequence", false)
            Wait(.05, false)
            SetVisible("MolotovSequence", true)

            Wait(.5, false)
            SetState("MolotovSequence","MolotovB")
            SetAlpha("Dark", 0.0)
            SetVisible("Dark", true)
            Scale("ThugsRunning", 1.5, 1)     --
            Wait(.5, false)

            SetState("MolotovSequence","MolotovC")
            Shake("MolotovSequence", 20.0, 3)
            Fade("Dark", 1.0, 1)
            Flame.PlayAnimation()
            Wait(2, false)

            Scale("ThugsRunning", 1.0, 20)     --
            SetAlpha("ThugsRunning", 1.0)
            Fade("Dark", 0.0, 2)
            Wait(3, false)

            Fade("Flame", 1.0, 20)
            Scale("Flame", 1.5, 100)     --
            SetVisible("MolotovSequence", false)
            Wait(3, false)

            Schedule(18, "Fade", "Flame", 0.0, 20)
            Fade("Dark", 1.0, 15)

            Schedule(10, "SetVisible", "SkinWalker" )
            Schedule(10.05, "SetVisible", "SkinWalker",false)
            Schedule(10.1, "SetVisible", "SkinWalker" )
            Schedule(10.15, "SetVisible", "SkinWalker",false)
            Schedule(10.2, "SetVisible", "SkinWalker" )
            Schedule(10.25, "SetVisible", "SkinWalker",false)

            Schedule(15, "SetVisible", "BigEye" )
            Schedule(15.05, "SetVisible", "BigEye",false)
            Schedule(15.1, "SetVisible", "BigEye" )
            Schedule(15.15, "SetVisible", "BigEye",false)

            Schedule(20, "SetVisible", "LegInjury" )
            Schedule(20.05, "SetVisible", "LegInjury",false)
            Schedule(20.15, "SetVisible", "LegInjury" )
            Schedule(20.2, "SetVisible", "LegInjury",false)
            Schedule(20.3, "SetVisible", "LegInjury" )
            Schedule(20.35, "SetVisible", "LegInjury",false)

            Schedule(25.1, "SetVisible", "Lua" )
            Schedule(25.15, "SetVisible", "Lua",false)
            Schedule(25.25, "SetVisible", "Lua" )
            Schedule(25.3, "SetVisible", "Lua",false)

            Schedule(30, "SetVisible", "Goya" )
            Schedule(30.05, "SetVisible", "Goya",false)

            Schedule(35.1, "SetVisible", "Skull" )
            Schedule(35.15, "SetVisible", "Skull",false)

            Wait(40, false)
            Flame.OnStopAnimation()
            SetNoise(false)

        end
        function self.OnCombine(itemId)
            if itemId == "MolotovFire" then
                StartSequence(self.OnEndSequence)
                RemoveEntity("MolotovFire")
            end
        end 
        
        
        return self
        end)()
    } -- TRASH CAN


}
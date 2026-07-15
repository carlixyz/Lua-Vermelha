return {
    { Entity = "Tunnel",  Textures = {
        {TunnelDay = "data/Scenes/Town/TunnelDay.jpg"},
        {TunnelNight = "data/Scenes/Town/TunnelNight.jpg"},
        {TunnelLua = "data/Scenes/Town/TunnelLua.jpg" },
        {TunnelSunset = "data/Scenes/Town/TunnelSunset.jpg" }}
    },


    { Clown = (function()
        local self = { FirstTimeTalk = true }
        function self.OnConstruct() return { Visible = false, Clickable = false, Textures = {
                { ClownFriendly =   "data/Actors/Clown/ClownFriendly.png"   },
                { ClownClose    =   "data/Actors/Clown/ClownClose.png"      },
                { ClownNeutral  =   "data/Actors/Clown/ClownNeutral.png"    },
                { ClownSad      =   "data/Actors/Clown/ClownSad.png"        },
                { ClownSurprise =  "data/Actors/Clown/ClownSurprise.png"    }
            }, CurrentImage     = "ClownNeutral" 
        }
        end

        function self.OnLookComment() Say("Frankly, I feel sorry for this guy..", 4.0) Say() 
        end

        function self.OnLook() StartSequence(self.OnLookComment) 
        end

        function self.TellJoke()
            local Jokes =
            {
                "Why did the skeleton avoid the party?\nHe had nobody to go with.",
                "Why don't graveyards get overcrowded?\nPeople are dying to get in.",
                "How do you know when a nightmare is over?\nThat's the funny part. You don't.",
                "Why did the scarecrow get promoted?\nHe was outstanding in his field.",
                "What did one wall say to the other?\nI'll meet you at the corner.",
                "Why did the bicycle fall over?\nIt was two-tired.",
                "What kind of music do mummies enjoy?\nWrap music.",
                "Why don't ghosts lie?\nYou can see right through them.",
                "What do you call a werewolf with a headache?\nAnything you want. Just not too loudly.",
                "Why was the clown feeling tired?\nHe had been fooling around all day."
            }

            SetState("Clown","ClownFriendly")
            Say("Tapioca", Jokes[math.random(#Jokes)], 6.0)
            Say("Tapioca", "Ha! Thank you, thank you.\nI'll be here until someone complains.", 5.0)
            SetState("Clown","ClownNeutral")
            self.TalkClown()
        end

        function self.TalkClown()
            Choice(
                { "Who are you, anyway?", function()
                    SetState("Clown","ClownFriendly")
                    Say("Tapioca", "Nobody important.\nJust a wandering street performer.", 4.0)
                    Say("Tapioca", "I juggle, paint faces\nand make children laugh.", 5.0)
                    SetState("Clown","ClownSad")
                    Say("Tapioca", "Or frighten strangers half to death...\napparently.", 4.0)
                    SetState("Clown","ClownNeutral")

                    Say("Tapioca", "I go wherever people spare a coin\nor leave some food behind.", 5.0)
                    Say("Tapioca", "It's a humble life...\nbut the road doesn't ask for rent.", 5.0)
                    SetState("Clown","ClownFriendly")
                    Say("Tapioca", "I paint smiles because mine\ndoesn't always stay.", 4.0)
                    SetState("Clown","ClownNeutral")
                    self.TalkClown()
                end },

                { "What can you tell me about this settlement?", function()
                    Say("Tapioca", "Very little.\nI only arrived a few days ago.", 4.0)
                    SetState("Clown","ClownSad")
                    Say("Tapioca", "I don't own enough\nto settle anywhere.", 4.0)
                    Say("Tapioca", "I move between towns,\nfairs and roadside festivals.", 5.0)
                    SetState("Clown","ClownNeutral")
                    Say("Tapioca", "But people here talk quietly\nafter sunset.", 4.0)
                    Say("Tapioca", "Whatever brought you here...\nI'd finish it quickly and leave.", 5.0)
                    self.TalkClown()
                end },

                { "Hey can you tell me a joke?", function() Say("Tapioca", "Sure, listen this") self.TellJoke() end },

                { "End conversation", function()
                    Say("Thiago", "Anyway, I should keep moving...", 3.0)
                    SetState("Clown","ClownFriendly")
                    Say("Tapioca", "Probably wise.\nWatch your head under the bridge.", 4.0)
                    SetState("Clown","ClownNeutral")
                    Say()
                    SetClickable("Clown")
                        
                end }
            )
        end

        function self.TalkStart()
            Wait(2.0,false)
            Scale("Clown", 1.0, 10.0)
            Say("Hello Buddie!", 2.0)
            SetState("Clown","ClownFriendly")
            Say("Tapioca", "I'm Tapioca the clown", 4.0)
            Say("...", 1.0)
            Shake("Clown", 24.0, 1.5)
            SetState("Clown","ClownSurprise")
            Say("Thiago", "What the hell?!\nYou nearly gave a stroke!", 4.0)
            Shake("Clown", 6.0, 0.5)
            Say("Thiago", "What were you thinking?", 3.0)
            SetState("Clown","ClownSad")
            Say("Tapioca", "Oops... I'm sorry.", 3.0)
            Say("Tapioca", "That was much funnier in my head.", 4.0)
            SetState("Clown","ClownNeutral")
            self.TalkClown()
        end

        function self.DoJumpScare()
            -- Add short StartSequence for Say()
            SetState("Clown","ClownClose")
            SetPosition("Clown",920)
            Move("Clown", 0, 0, 0.2)
            --Scale("Clown", 1.2, .25)
            --Shake("Clown", 64.0, 2.0)
            Schedule(0.2, "Scale", "Clown", " 1.2", "0.25")
            Schedule(0.2, "Shake", "Clown", "64", "2")
            SetVisible("Clown")
            self.OnInteract()
        end

        function self.OnInteract()
            if self.FirstTimeTalk then
                self.FirstTimeTalk = false
                StartSequence(self.TalkStart)
            else
                StartSequence(self.TalkClown)
            end
        end

        return self
        end)()
    },



    { Quad = { OnConstruct = function() return { NameId = "MoveForward", Cursor = "MUp", 
        Pos = { x = 0, y = 0 }, Size = { Width = 920, Height = 370 }} end, 
        OnInteract = function() Clown.DoJumpScare() SetClickable("MoveForward", false) SetClickable("ReturnToPlazaBack") end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "ReturnToPlazaBack", Cursor = "MDown", Pos = { x = 0, y = 370 }, 
        Size = { Width = 920, Height = 140 }} end, OnInteract = function() SwipeScene("PlazaExit", "Up") end } 
    }
}
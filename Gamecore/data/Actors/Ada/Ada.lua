

return (function()
    local self = {
        Guidance = true,
        TalkAnimID = 0,
        TalkFrame = 0,
        TalkCount = 0,

        TalkTimeMin = 4,
        TalkTimeMax = 9,
        TalkAmount = 4,

        QuietTimeMin = 10,
        QuietTimeMax = 20,
        QuietAmount = 10,
    }

    function self.OnConstruct()
        return {
            NameView = "Ada",
            Visible = true,
            Clickable = false,
            Pos = { x = 370, y = 0 },
            Textures = {
                { ANeutral =    "data/Actors/Ada/ANeutral.png"    },
                { AHappy =      "data/Actors/Ada/AHappy.png"      },
                { ALaugh =      "data/Actors/Ada/ALaugh.png"      },
                { AAprove =     "data/Actors/Ada/AAprove.png"     },
                { ABonkers =    "data/Actors/Ada/ABonkers.png"    },
                { ACharming =   "data/Actors/Ada/ACharming.png"   },
                { ADuckFace =   "data/Actors/Ada/ADuckFace.png"   },
                { AExplaining = "data/Actors/Ada/AExplaining.png" },
                { AExplains =   "data/Actors/Ada/AExplains.png"   },
                { AFrozen =     "data/Actors/Ada/AFrozen.png"     },
                { AirGuitar =   "data/Actors/Ada/AirGuitar.png"   },
                { ASad =        "data/Actors/Ada/ASad.png"        },
                { AShamed =     "data/Actors/Ada/AShamed.png"     },
                { AShruggin =   "data/Actors/Ada/AShruggin.png"   },
                { ASmile =      "data/Actors/Ada/ASmile.png"      },
                { ASurprise =   "data/Actors/Ada/ASurprise.png"   },
                { ATalkClose =  "data/Actors/Ada/ATalkClose.png"  },
                { ATalkOpen =   "data/Actors/Ada/ATalkOpen.png"   },
                { AThought =    "data/Actors/Ada/AThought.png"    },
                { AStandUp =    "data/Actors/Ada/AStandUp.png"    }
            }
        }
    end

    function self.OnInit()
        print("called Ada.OnInit")
    end

    function self.OnDeinit()
        print("called Ada.OnDeinit")
        self.StopTalk()
    end

    function self.StartTalk()
        if self.TalkAnimID == 0 then
            self.TalkAnimID = ScheduleRepeat(0.15, "AnimateAdaTalk", "CancelAdaTalk")
        end
    end

    function self.StopTalk()
        if self.TalkAnimID ~= 0 then
            CancelScheduled(self.TalkAnimID)
            self.TalkAnimID = 0
        end

        SetState("Ada", "ATalkClose")
    end

    function AnimateAdaTalk()
        if self.TalkCount <= self.TalkAmount and self.TalkFrame == 0 then
            SetState("Ada", "ATalkOpen")
            self.TalkFrame = 1
        else
            SetState("Ada", "ATalkClose")
            self.TalkFrame = 0
        end

        self.TalkCount = self.TalkCount + 1

        if self.TalkCount > self.QuietAmount then
            self.TalkCount = 0
            self.TalkAmount = math.random(self.TalkTimeMin, self.TalkTimeMax)
            self.QuietAmount = math.random(self.QuietTimeMin, self.QuietTimeMax)
        end
    end

    function self.OnInteract()
        print("called Ada.OnInteract")

        --Wobble("Ada", 5, 3)

        if self.Guidance then
            SetState("Ada", "ASmile")
            Schedule(0.5, "SetState", "Ada", "ATalkClose")
            print("Ok, let's go")
        end
    end

    function self.OnLook()
        print("called Ada.OnLook")
    end

    function self.TalkAda()
        Choice(
            { "I'm done, let's go to the hospital",
                function()
                    Say("Alright Let me show you the way", 3.0)
                    SetEntityScene("Ada", "Global")
                    SetAlpha("Dark", 1)
                    --BlendScene("GuestRoom")
                end },

            { "Ask about the Mansion", 
                function() 
                    Say("Well I believe the Mannor is like almost 100 years old", 3)
                    Say()
                    --StartSequence(self.DoOptionsMenu)
                end },

            { self.StatusEnabled, "About the family",
                function()
                    Say("Oh we're like 5 brothers")
                    Say()
                    --self.DoOptionsMenu()
                end },

                
            { "Nevermind", function() Say("Thiago","Oh nevermind,\njust forgot what I was going to say", 1.5) end }
        )
    end
    
    function self.ContinueOnboarding()
    end

    function self.TalkAboutAdaDisease()
    end

    function self.TalkAboutFamily()
    end

    function self.TalkAboutMansion()
    end

    function self.TalkAboutPolice()
    end

    return self
end)()


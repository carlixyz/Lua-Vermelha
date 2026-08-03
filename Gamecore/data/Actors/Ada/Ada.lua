function StopAdaTalk()
    Ada.StopTalk()
end

return (function()
    local self = {
        Guidance = true,
        LupusAware = false,
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
            Visible = false,
            Clickable = false,
            Pos = { x = 400, y = 0 },
            Textures = {
                { ANeutral =    "data/Actors/Ada/ANeutral.png"    },
                { AHappy =      "data/Actors/Ada/AHappy.png"      },
                { ALaught =      "data/Actors/Ada/ALaugh.png"      },
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
        --print("called Ada.OnInteract")
        --Wobble("Ada", 5, 3)

        if self.Guidance then
            SetState("Ada", "ASmile")
            Schedule(0.5, "SetState", "Ada", "ATalkClose")
            SetClickable("Ada", false)
            StartSequence(self.TalkAda)
        end
    end

    function self.OnLook()
        print("called Ada.OnLook")
    end

    function self.TalkAda()
        Choice(
            { self.Guidance, "Where's the hospital? What I should do?",
                function()
                    if not self.LupusAware then
                        
                        Say("Thiago","Hey I want to see a doctor", 3.0)
                        Ada.StartTalk()
                        Say("Ada","Yes, I'm affraid that You'll need to go to the town's Hospital", 5.0)
                        Say("Ada","You can take the town's path that's aside our house front", 5.0)
                        Ada.StopTalk()
                        Say("Thiago","Oh but I'm not sure about going alone", 5.0)
                        Say("Thiago","I might miss the path, can you guide me?", 6.0)

                        SetState("Ada","AThought")
                        Say("Ada","Mhhh Well, I wish I could but..", 4.0)
                        Say("Thiago","What's up?", 3.0)

                        Ada.StartTalk()
                        Say("Ada","My mother doesn't allow me to leave the Mannor", 4.0)
                        Schedule(2.0, "StopAdaTalk")
                        Schedule(2.5, "SetState", "Ada", "AShruggin")
                        Say("Ada","Because I suffer from a chronic illness,\nI can't go too far", 5.0)

                        Say("Thiago","Oh no, Didn't knew about it, I'm sorry", 3.0)
                        SetState("Ada","AShamed")
                        Say("Ada","Oh it's ok, don't worry", 3.0)
                        SetState("Ada","AAprove")
                        Say("Ada","Take this, Remember to close the door when leaving", 4.0)
                        self.LupusAware = true
                        SetState("MainKey", "MainKeyBase")
                        PickUp("MainKey",2)
                    end
                    Ada.StartTalk()
                    Say("Ada","So You'll need to get the path aside my house", 4.0)
                    Say("Ada","it'll take you to the town's Hospital", 4.0)
                    Say("Ada","I know You can do it, The town is pretty close", 4.0)
                    Ada.StopTalk()
                    Say("Thiago","Ok..", 3.0)
                    SetClickable("Ada")
                    --SetEntityScene("Ada", "Global")
                end },


            { "Ask to know more about You", function() self.TalkAboutAda() end },

            { "Ask to know more about this place", function() self.TalkAboutValley() end },
                
            { "end conversation", function() Say("Thiago","Oh nevermind,\nnothing to say right now", 4.0)
               Say("Ada", "See you later!", 3.0) Say() SetClickable("Ada") end }
        )
    end


    function self.TalkAboutAda()
        Say("Oh, what do you want to know?")
        Choice(
            { self.LupusAware, "About the illness",
                function()
                    --self.TalkAboutAdaDisease()
                    SetState("Ada","AFrozen")
                    Say("Thiago","I'm still worried,\nWhat is your health condition?", 6.0)
                    SetState("Ada","AShamed")
                    Say("Ada","Well I've a systemic erythematosus", 3.0)
                    SetState("Ada","AExplaining")
                    Say("Ada","Basically my body defends of itself", 3.0)

                    Say("Thiago","Ouch sounds painful", 4.0)
                    SetState("Ada","AExplains")
                    Say("Ada","It depends on the day, I'm accostumed to the pain", 5.0)
                    Say("Thiago","I'm so sorry", 4.0)
                    SetState("Ada","AShruggin")
                    Say("Ada","Every morning starts with a handful of pills", 4.0)
                    Say("Ada","But I'm fine I guess", 5.0)

                    Say("Thiago","You know, I'm a medic visitor, ", 4.0)
                    SetState("Ada","AFrozen")
                    Say("Thiago","maybe can be of help getting mediccines later", 4.0)
                    SetState("Ada","ACharming")
                    Say("Ada","Oh that sounds great..", 3.0)
                    Say("Ada","thank you!", 3.0)
                    Ada.StopTalk()

                    self.TalkAda()

                end },

            { "Do you have brothers?",
                function()

                    Ada.StartTalk()
                    Say("Ada","Well I've two brothers", 3.0)
                    Say("Ada","Lukas is my older brother,", 7.0)
                    Say("Ada","He works all day with my mother taking care on the business", 7.0)
                    Say("Ada","never got married or had a stable partner", 4.0)
                    Schedule(1.5, "StopAdaTalk")

                    Schedule(4.0, "SetState", "Ada", "AShamed")
                    Say("Ada","But besides that, He's a nice guy", 3.0)
                    Say("Ada","And regarding the youngest one...", 4.0)
                    Say("Ada","..")

                    Say("Thiago","What's up?..", 4.0)
                    SetState("Ada","ASad")
                    Say("Ada","Well..", 4.0)
                    Say("Thiago","..", 3.0)
                    Ada.StartTalk()
                    Say("Ada","Viktor used to be a bit problematic", 4.0)

                    Schedule(1.5, "StopAdaTalk")
                    Schedule(2.0, "SetState", "Ada", "AThought")
                    Say("Ada","He Have had some serious mental issues in the past", 5.0)
                    Say("Ada","That's all I can say about Him really", 4.0)
                    Schedule(0.5, "SetState", "Ada", "AShruggin")
                    Say("Thiago","oh sorry, I didn't mean to make you uncomfortable", 5.0)

                    Ada.StartTalk()
                    Say("Ada","It's ok, don't worry", 3.0)
                    Say("Ada","I guess every family has their black sheep after all", 5.0)
                    Schedule(1.5, "StopAdaTalk")
                    Say("Thiago","Oh Gotcha", 3.0)
                    self.TalkAda()

                    --Say()
                end },

            { "Do you have sisters?",
                function()
                    SetState("Ada","AFrozen")
                    Say("Ada","Oof Do you really want to know about her?")
                    Say("Thiago","yeah, I suppose?")
                    Ada.StartTalk()
                    Say("Ada","Well..", 1.0)
                    Schedule(1.0, "StopAdaTalk")
                    Schedule(1.5, "SetState", "Ada", "AThought")
                    Say("Ada","Regina is my big sister", 4.0)
                    Say("Ada","Mhhh..", 4.0)

                    Ada.StartTalk()
                    Schedule(1.0, "StopAdaTalk")
                    Schedule(1.5, "SetState", "Ada", "AShamed")
                    Say("Ada","I shouldn't talk behind her back", 4.0)
                         
                    Ada.StartTalk()
                    Schedule(1.0, "StopAdaTalk")
                    Schedule(1.5, "SetState", "Ada", "AShamed")
                    Say("Ada","My best advice is to stay away from Her", 4.0)
                    Say("Thiago","Oh You don't seem to get along very well", 3.0)

                    Ada.StartTalk()
                    Say("Ada","Welp yeah.. I guess she's fine", 3.0)
                    Say("Ada","She is going to marry her fiance Alex.", 4.0)
                    Schedule(1.0, "StopAdaTalk")
                    Schedule(1.5, "SetState", "Ada", "ABonkers")
                    Schedule(2.5, "StopAdaTalk")
                    Say("Ada","Who is a fool beyond measure\ndespite his family's fortune.", 5.0)

                    Say("Thiago","Ok ok, I understand", 3.0)
                    Ada.StartTalk()
                    Say("Ada","Honestly it's your own choice", 3.0)
                    Say("Ada","But beware of that crazy bitch", 3.0)
                    Ada.StopTalk()
                    self.TalkAda()
                end },
                
            { "About Her parents", 
                function()
                    Ada.StartTalk()
                    Say("Ada","Oh you knew already my mom..", 4.0)
                    Schedule(4.0, "StopAdaTalk")
                    Say("Ada","My father fell in love with her at very young age\nthey got married inmediatelly", 7.0)

                    Say("Thiago","Ah I think I see him in the center of the family photo?", 6.0)
                    Ada.StartTalk()
                    Schedule(1.5, "StopAdaTalk")
                    Schedule(2.0, "SetState", "Ada", "AThought")
                    Say("Ada","Yes, that one is!", 3.0)
                    Say("Ada","Sadly he's not with us anymore..", 4.0)
                    Ada.StartTalk()
                    Say("Thiago","Oh I'm so sorry to hear that", 6.0)
                    Schedule(2.0, "StopAdaTalk")
                    Say("Ada","Oh don't worry, He passed away long time ago", 5.0)

                    Say("Thiago","What happened to him?", 3.0)
                    SetState("Ada","AExplains")
                    Say("Ada","He died on a bike accident", 4.0)
                    Say("Thiago","Oh that's terrible'", 3.0)
                    SetState("Ada","AExplaining")
                    Schedule(2.0, "StopAdaTalk")
                    Say("Ada","Yeah He and his brother were crazy of motorbikes", 5.0)
                    SetState("Ada","AShruggin")
                    Say("Ada","So let's say he did it his way", 4.0)
                    Schedule(2.0, "StopAdaTalk")
                    self.TalkAda()
                end 
            }
        )

    end


    function self.TalkAboutValley()
       Say("Thiago", "Hey there's something I'm curious about this place", 5)
        Ada.StopTalk()
       Say("Ada", "Oh what is it?", 3)
       Choice(
           { "About the Residence", function() self.TalkAboutMansion() end },

           { "About the police meeting", function() self.TalkAboutPolice() end },

           { IsEntityInScene("Matches", "Inventory"), "About the Lua vermelha", function() self.TalkAboutLuaFestival() end },
                
           {  "Nevermind", function() Say("Thiago","Oh nevermind,\njust forgot what I was going to say") self.TalkAboutAda() end }
       ) 

    end

    function self.TalkAboutMansion()
        Say("Thiago","This house is very curious,\n all rooms door are oriented to that open gallery ", 5)
        Ada.StartTalk()
        Say("Ada","Yeah Well I believe the Mannor is like almost 100 years old", 4)
        Say("Ada","Originally there was nothing here but the forest valley,\nNeither the settlement near existed", 7)
        Say("Ada","When my parents came from europe,\nThey built it as a farm with the style of that time", 6)
        Schedule(2.0, "StopAdaTalk")
        Schedule(3.0, "SetState", "Ada", "AHappy")
        Say("Ada","Then the family started to grow\nSo the house had to do the same too", 6)
        Say("Thiago","Oh that's an amazing piece of history", 5)
        Ada.StartTalk()
        Schedule(2.0, "StopAdaTalk")
        Schedule(3.0, "SetState", "Ada", "AShruggin")
        Say("Ada","Yeah hahaha, it sounds like a Garcia Marquez novel", 4)
        Ada.StopTalk()

        self.TalkAda()
        --Say()
    end

    function self.TalkAboutPolice()
        Say("Thiago", "What was that talk with officiers you mother mentioned?", 4)
        Ada.StartTalk()
        Say("Ada", "Oh yeah, the Police, right", 3)
        Say("Ada", "Well, it's like a long story", 3)
        Schedule(2.0, "StopAdaTalk")
        Schedule(2.5, "SetState", "Ada", "AShruggin")
        Say("Ada", "Basically my mother is colaborating with the Police", 5)
        Say("Thiago", "The police? what are they looking for?", 4)

        Ada.StartTalk()
        Say("Ada", "There were some incidents in the area near our farm limits", 5)
        Schedule(2.0, "StopAdaTalk")
        Say("Ada", "I think there's a man missing...\nand the overlook was the last place where He was seen", 7)
        Say("Thiago", "Ohh Do you have an overlook?", 4)

        Ada.StartTalk()
        Say("Ada", "Well, there's an old path to the espretador peak very close here", 6)
        Schedule(2.8, "StopAdaTalk")
        Schedule(3.0, "SetState", "Ada", "AShruggin")
        Say("Ada", "But is not really part of our lands", 5)
        Say("Thiago", "Oh interesting", 3)
        Ada.StopTalk()

        self.TalkAda()
        
    end

    function self.TalkAboutLuaFestival()
        Say("Thiago", "Hey What is this red Lua thing?", 4)
        SetState("Ada","ASmile")
        Say("Ada", "Ah you mean the Lua Vermelha festival!", 3)
        Say("Thiago", "yes, that one, is it an event or what?", 3)
        
        Ada.StartTalk()
        Say("Ada", "Yes, it's a local celebration we've in the valley", 5)
        Say("Ada", "like a small carnival that the town prepares to receive the red moon", 5)
        Ada.StopTalk()
        Say("Thiago", "Mhhh Very interesting, Does it happens always at this time of the year?", 6)

        Ada.StartTalk()
        Say("Ada", "Yeah I believe it's an atmospheric phenomenon\ngenerated by mountain's vapor minerals.", 9)
        Say("Ada", "Not sure about the actual science behind it though", 5)
        Schedule(2.0, "StopAdaTalk")
        Say("Ada", "The party is tomorrow\nso you're more than welcome if you stay one more day.", 5)
        SetState("Ada", "ACharming")
        Say("Thiago", "Well thanks, I can't promise anything but I'll think about it.", 5)
        Schedule(2.0, "StopAdaTalk")

        self.TalkAda()

    end

    return self
end)()


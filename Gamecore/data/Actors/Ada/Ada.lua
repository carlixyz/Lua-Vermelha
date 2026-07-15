
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
        --print("called Ada.OnInteract")
        --Wobble("Ada", 5, 3)

        if self.Guidance then
            SetState("Ada", "ASmile")
            Schedule(0.5, "SetState", "Ada", "ATalkClose")
            StartSequence(self.TalkAda)
        end
    end

    function self.OnLook()
        print("called Ada.OnLook")
    end

    function self.TalkAda()
        Choice(
            { self.Guidance, "What's the next step? What I should do?",
                function()
                    if not self.LupusAware then
                        Say("Thiago","Hey I want to see a doctor", 3.0)
                        
                        --Ada.StartTalk()
                        --Ada.StopTalk()
                        --SetState("Ada", "AAprove")

                        Say("Ada","Yes, I'm affraid that You'll need to go to the town's Hospital", 5.0)
                        Say("Ada","You can take the town's path that's aside our house front", 5.0)
                        Say("Thiago","I'm not sure about going alone", 5.0)
                        Say("Thiago","I'll might get lost, can you guide me?", 6.0)
                        Say("Ada","Mhhh Well, I wish I could but..", 4.0)
                        Say("Thiago","What's up?", 3.0)
                        Say("Ada","My mother doesn't allow me to leave the Mannor", 4.0)
                        Say("Ada","Because I suffer from a chronic illness, I can't go too far", 5.0)
                        Say("Thiago","Oh no, Didn't knew about it, I'm sorry", 3.0)
                        Say("Ada","Oh it's ok, don't worry", 3.0)
                        Say("Ada","Take this, Remember to close the door when leaving", 4.0)
                        self.LupusAware = true
                        PickUp("MansionKey",2)
                    end
                    Say("Ada","So You'll need to get the path aside my house", 4.0)
                    Say("Ada","it'll take you to the town's Hospital", 4.0)
                    Say("Ada","I know You can do it, The town is pretty close", 4.0)
                    Say("Thiago","Ok..", 3.0)

                    --SetEntityScene("Ada", "Global")
                end },


            { "Ask to know more about You", function() self.TalkAboutAda() end },

            { "Ask to know more about this place", function() self.TalkAboutValley() end },
                
            { "end conversation", function() Say("Thiago","Oh nevermind,\nnothing to say right now", 4.0)
               Say("Ada", "See you later!", 3.0) Say() end }
        )
    end


    function self.TalkAboutAda()
        Say("Oh, what do you want to know?")
        Choice(
            { self.LupusAware, "About the illness",
                function()
                    --self.TalkAboutAdaDisease()
                    Say("Thiago","I'm still worried,\nWhat is your health condition?", 6.0)
                    Say("Ada","Well I've a systemic erythematosus", 3.0)
                    Say("Ada","Basically my body defends of itself", 3.0)
                    Say("Thiago","Ouch sounds painful", 4.0)
                    Say("Ada","It depends on the day, I'm accostumed to the pain", 5.0)
                    Say("Thiago","I'm so sorry", 4.0)
                    Say("Ada","I'm fine I guess", 5.0)
                    Say("Thiago","You know, I'm a medic visitor, ", 4.0)
                    Say("Thiago","maybe can be of help getting mediccines later", 4.0)
                    Say("Ada","Oh that sounds good!", 3.0)
                    self.TalkAda()

                end },

            { "Do you have brothers?",
                function()

                    Say("Ada","Well I've two brothers", 3.0)
                    Say("Ada","Lukas is my older brother,", 7.0)
                    Say("Ada","He works all day with my mother taking care on the business", 7.0)
                    Say("Ada","never got married or had a stable partner", 4.0)
                    Say("Ada","But besides that, He's a nice guy", 4.0)
                    Say("Ada","And regarding the youngest one...", 4.0)
                    Say("Ada","..")

                    Say("Thiago","What's up?..", 4.0)
                    Say("Ada","Well..", 4.0)
                    Say("Thiago","..", 3.0)
                    Say("Ada","Viktor used to be a bit problematic", 5.0)
                    Say("Ada","He Have had some mental issues in the past", 4.0)
                    Say("Ada","That's all I can say about Him really", 4.0)
                    Say("Thiago","oh sorry, I didn't mean to make you uncomfortable", 5.0)
                    Say("Ada","It's ok, don't worry", 3.0)
                    Say("Ada","I guess every family has their black sheep after all", 5.0)
                    Say("Thiago","Gotcha", 3.0)
                    self.TalkAda()

                    --Say()
                end },

            { "Do you have sisters?",
                function() 
                    Say("Ada","Oof Do you really want to know that?")
                    Say("Thiago","..")
                    Say("Ada","Well..", 1.0)
                    Say("Ada","Yeah Regina is my big sister", 4.0)
                    Say("Ada","Mhh..", 4.0)
                    Say("Ada","I shouldn't talk behind her back", 4.0)
                    Say("Ada","My best advice is to stay away from Her", 4.0)
                    Say("Thiago","Oh You don't seem to get along very well", 3.0)
                    Say("Ada","Welp yeah.. I guess she's fine", 4.0)
                    Say("Ada","She is going to marry her fiancé Alex.", 4.0)
                    Say("Ada","Who is a fool beyond measure, despite his family's fortune.", 5.0)
                    Say("Thiago","Ok ok, I understand", 3.0)
                    Say("Ada","Honestly it's your own choice", 4.0)
                    Say("Ada","But beware of that crazy bitch", 4.0)
                    self.TalkAda()
                end },
                
            { "About Her parents", 
                function() 
                    Say("Ada","Oh you knew already my mom..", 4.0)
                    Say("Ada","My father fell in love with her at very young age\nthey got married inmediatelly", 7.0)
                    Say("Thiago","Ah I think I see him in the center of the family photo?", 6.0)
                    Say("Ada","Yes, that one is!", 3.0)
                    Say("Ada","Sadly he's not with us anymore..", 4.0)
                    Say("Thiago","Oh I'm so sorry to hear that, what happened to him?", 6.0)
                    Say("Ada","Oh don't worry, He passed away long time ago", 5.0)
                    Say("Thiago","What happened to him?", 3.0)
                    Say("Ada","He died on a bike accident", 4.0)
                    Say("Thiago","Oh that's terrible'", 3.0)
                    Say("Ada","Yeah He and his brother were crazy of motorbikes", 5.0)
                    Say("Ada","So let's say he did it his way", 4.0)
                    self.TalkAda()
                end }
        )

    end


    function self.TalkAboutValley()
       Say("Thiago", "Hey there's something I'm curious about this place", 5)
       Say("Ada", "Oh what is it?", 3)
       Choice(
           { "About the Mansion", function() self.TalkAboutMansion() end },

           { "About the police meeting", function() self.TalkAboutPolice() end },

           { "About the Lua vermelha", function() self.TalkAboutLuaFestival() end },
                
           {  "Nevermind", function() Say("Thiago","Oh nevermind,\njust forgot what I was going to say") self.TalkAboutAda() end }
       ) 

    end

    function self.TalkAboutMansion()
        Say("Thiago","This house is very curious,\n all rooms door are oriented to that open gallery ", 5)
        Say("Ada","Yeah Well I believe the Mannor is like almost 100 years old", 4)
        Say("Ada","Originally there was nothing here but the forest valley,\n neither the settlement near existed", 7)
        Say("Ada","When my parents came from europe,\nThey built it as a farm with the style of that time", 6)
        Say("Ada","Then the family started to grow\nSo the house had to do the same too", 6)
        Say("Thiago","Nice, that's an amazing piece of history", 5)
        Say("Ada","Yeah hahaha, it sounds like a Garcia Marquez novel", 4)
        self.TalkAda()

        --Say()
    end

    function self.TalkAboutPolice()
        Say("Thiago", "What was that talk with officiers you mother mentioned?", 3)
        Say("Ada", "Oh yeah, the Police, right", 3)
        Say("Ada", "Well, it's like a long story", 3)
        Say("Ada", "Basically my mother is colaborating with the Police", 5)
        Say("Thiago", "The police? what are they looking for?", 5)
        Say("Ada", "There were some incidents in the area near our farm limits", 5)
        Say("Ada", "I think there's a man missing...\nand the overlook was the last place where He was seen", 7)
        Say("Thiago", "Ohh Do you have an overlook?", 4)
        Say("Ada", "Well not really, there's an old path to the espretador overlook very close here", 6)
        Say("Ada", "But technically is not part of our lands", 5)
        Say("Thiago", "Oh interesting", 3)
        self.TalkAda()
        
    end

    function self.TalkAboutLuaFestival()
        Say("Thiago", "Hey What is this red Lua thing?", 4)
        Say("Ada", "Ah you mean the Lua Vermelha festival!", 3)
        Say("Thiago", "yes, that one, is it an event or what?", 3)
        Say("Ada", "Yes, it's a local celebration we've in the valley", 5)
        Say("Ada", "like a small carnival that the town prepares to receive the red moon", 5)

        Say("Thiago", "Mhhh Very interesting, Does it happens always at this time of the year?", 6)
        Say("Ada", "I believe it's an atmospheric phenomenon\nthat occurs with the fog and the mountain's minerals.", 9)
        Say("Ada", "Not sure about the actual science behind it though", 5)
                
        Say("Ada", "The party is tomorrow, so you're more than welcome if you stay one more day.", 5)
        Say("Thiago", "Well thanks, I can't promise anything but I'll think about it.", 5)
        self.TalkAda()

    end

    return self
end)()


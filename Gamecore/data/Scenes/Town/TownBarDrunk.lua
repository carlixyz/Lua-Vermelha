
function StopDrunkTalk()
    DrunkMan.StopTalk()
end
return {

    { Quad = (function()
        local self = {
            Invite = false,
            TalkOpened = false,

            NameCompleted = false,
            WorkCompleted = false,
            FamilyCompleted = false,
            FriendsCompleted = false,

            PlaceUnlocked = false,
            FamilyUnlocked = false,

            ValleyTalk = 0,
            FestivalUnlocked = false,
            MissingUnlocked = false,
            MaidenUnlocked = false,

            FestivalCompleted = false,
            MissingCompleted = false,
            MaidenCompleted = false,

            SchwarzUnlocked = false,
            Finished = false,
            CheckedAlive = false
    }

    function self.OnConstruct()
        return {
            NameId = "DrunkConversation",
            NameView = "BB Torres",
            Pos = { x = 225, y = 0 },
            Size = { Width = 600, Height = 370 }
        }
    end

    function self.OnCombine(itemId)
        if itemId == "Beer" and not self.Invite then
            self.Invite = true
            SetState("DrunkMan","DrunkHappy")
            StartSequence(self.OnOpenTalk)
        end
    end


    -- MAIN TALK
    function self.Talk()
        Choice(
            { "About Beer", function() self.TalkBeer() end },

            { "About him", function() self.TalkAboutHim() end },

            { self.PlaceUnlocked, "About this place", function() self.TalkPlace() end },

            { self.SchwarzUnlocked, "About the Schwarz family", function() self.TalkSchwarz() end }
        )
    end


    -- BEER
    function self.TalkBeer()
        local name = "Old Drunk"
        if self.NameCompleted then
            name = "BB Torres"
        end

        local BeerTalk = {
            function()
                Say("Thiago", "How's the beer?", 3.0)
                
                DrunkMan.StartTalk()
                Say(name, "Cold enough to forgive me", 3.0)
                Say(name, "Warm beer remembers everything", 4.0)
                DrunkMan.StopTalk()
            end,

            function()
                Say("Thiago", "You drink here often?", 3.0)

                DrunkMan.StartTalk()
                Say(name, "Never", 2.0)
                Say(name, "I simply wake up here most afternoons", 4.0)
                DrunkMan.StopTalk()
            end,

            function()                   
                DrunkMan.StartTalk()
                Say(name, "Beer is honest", 3.0)
                Say(name, "It tells you exactly why your head hurts", 4.0)
                DrunkMan.StopTalk()

            end,

            function()
                Say("Thiago", "My work made me spent half my life on the road", 4.0)

                DrunkMan.StartTalk()
                Say(name, "And I spend mine avoiding it", 3.0)
                Say(name, "Between us, we cover everything", 4.0)
                DrunkMan.StopTalk()
            end,

            function()
                Say("Thiago", "I'm a medical vendor", 3.0)

                DrunkMan.StartTalk()
                Say(name, "You sell health", 3.0)
                Say(name, "I invest in liver damage", 3.0)
                Say(name, "Practically the same profession", 4.0)
                DrunkMan.StopTalk()

            end
        }

        BeerTalk[math.random(#BeerTalk)]()
        self.Talk()
    end


      
    -- ABOUT HIM
    function self.TalkAboutHim()
        Choice(
            { "What's your name?", function()
                DrunkMan.StopTalk()
                if not self.NameCompleted then
                    self.NameCompleted = true
                    Say("Thiago", "I should probably know your name", 4.0)

                    DrunkMan.StartTalk()
                    Say("Old Drunk", "I have one, but it's too much name for one man", 5.0)
                    DrunkMan.StopTalk()
                end

                DrunkMan.StartTalk()
                Say("BB Torres", "Bernardo Batista Torres", 3.0)
                Say("BB Torres", "But BB is lighter to carry", 4.0)
                DrunkMan.StopTalk()

                self.Talk()
            end },

            { self.NameCompleted, "What do you do around here?", function()
                if not self.WorkCompleted then
                    self.WorkCompleted = true
                    self.PlaceUnlocked = true

                    DrunkMan.StartTalk()
                    Say("BB Torres", "I keep civilization alive", 3.0)
                    Say("BB Torres", "Fill road holes, paint signs, repair little bridges", 5.0)
                    Say("BB Torres", "A man with a shovel learns the valley", 4.0)
                    DrunkMan.StopTalk()
                    Say("Thiago", "Learns what about it?", 3.0)
                    DrunkMan.StartTalk()
                    Say("BB Torres", "Where every road goes", 3.0)
                else
                    DrunkMan.StartTalk()
                    Say("BB Torres", "Learn where every road goes", 3.0)
                end
                    
                Say("BB Torres", "And which ones ends in a pitfall", 4.0)
                DrunkMan.StopTalk()

                self.Talk()
            end },

            { self.FamilyUnlocked, "Do you have family here?", function()
                if not self.FamilyCompleted then
                    self.FamilyCompleted = true
                    self.SchwarzUnlocked = true

                    SetState("DrunkMan","DrunkIdle")
                    Say("Thiago", "You mentioned your father before", 4.0)
                    DrunkMan.StartTalk()
                    Schedule(2.0, "StopDrunkTalk" )
                    Say("BB Torres", "Did I?", 3.0)
                    Say("Thiago", "You did", 2.0)

                    DrunkMan.StartTalk()
                    Say("BB Torres", "Damn beer talks too much", 3.0)
                    Say("BB Torres", "Good man, my father", 3.0)
                    Say("BB Torres", "Hard hands, terrible singing", 4.0)
                    Say("BB Torres", "He's been dead twelve years now", 4.0)
                    DrunkMan.StopTalk()
                    Say("Thiago", "Oh I'm sorry", 3.0)
                else
                    DrunkMan.StartTalk()
                    Say("BB Torres", "I miss my father", 3.0)
                end

                DrunkMan.StartTalk()
                Say("BB Torres", "Wish I could visit him more often", 4.0)
                Say("BB Torres", "But the cemetery is near the Schwarz land", 4.0)
                Schedule(3.0, "StopDrunkTalk" )
                Say("BB Torres", "And that place is cursed", 4.0)

                self.Talk()
            end },

            { self.WorkCompleted, "What about your friends?", function()
                if not self.FriendsCompleted then
                    self.FriendsCompleted = true
                    Say("Thiago", "What about friends?", 3.0)

                    DrunkMan.StartTalk()
                    Say("BB Torres", "Had plenty once", 3.0)
                    Say("BB Torres", "Then one left for Porto Alegre", 4.0)
                    Say("BB Torres", "Another went north looking for work", 4.0)
                    Say("BB Torres", "Smart people", 3.0)
                end

                DrunkMan.StartTalk()
                Say("BB Torres", "They went looking for hope", 4.0)
                Schedule(2.0, "StopDrunkTalk" )
                Schedule(2.5, "SetState", "DrunkMan", "DrunkIdle")
                Say("BB Torres", "And I'm still looking for my keys", 4.0)

                self.Talk()
            end }
        )
    end



    -- ABOUT THIS PLACE
    function self.TalkPlace()
        Choice(
            { "Tell me about the Capao Seco Valley", function() self.TalkValley() end },

            { self.FestivalUnlocked, "What's wrong with Lua Vermelha?", function() self.TalkFestival() end },

            { self.MissingUnlocked, "Who's that missing man that police's looking for?", function() self.TalkMissing() end },

            { self.MaidenUnlocked, "What about the falling maiden?", function() self.TalkMaiden() end }
        )
    end


    -- VALLEY
    function self.TalkValley()
        if self.ValleyTalk == 0 then
            self.ValleyTalk = 1
            self.FestivalUnlocked = true
            SetState("DrunkMan", "DrunkIdle")
            Say("Thiago", "What can you tell me about Capao Seco?", 4.0)

            DrunkMan.StartTalk()
            Say("BB Torres", "It's an interesting valley...", 3.0)
            Say("BB Torres", "Mountains, forests, the Antares river", 4.0)
            Say("BB Torres", "Especially beautiful from somewhere else", 4.0)
            Say("BB Torres", "Unfortunately, sometimes a red moon rises", 4.0)
            Say("BB Torres", "Then people start to behave strangely", 3.0)
            DrunkMan.StopTalk()


        elseif self.ValleyTalk == 1 then
            self.ValleyTalk = 2
            self.MissingUnlocked = true

            SetState("DrunkMan", "DrunkIdle")
            Say("Thiago", "Anything else about the valley?", 4.0)
            DrunkMan.StartTalk()
            Say("BB Torres", "The mountains are old", 3.0)
            Say("BB Torres", "Older than the roads, older than this town", 4.0)
            DrunkMan.StopTalk()
            Say("Thiago", "I suppose most mountains are", 3.0)

            DrunkMan.StartTalk()
            Say("BB Torres", "Some paths run dangerously close to the precipices", 5.0)
            Say("BB Torres", "Sooner or later, you look down into the abyss", 5.0)
            Schedule(3.0, "StopDrunkTalk" )
            Say("BB Torres", "And realize it has been looking back at you", 5.0)

            Say("Thiago", "That's a bit dramatic", 3.0)
            DrunkMan.StartTalk()
            Say("BB Torres", "You can laugh", 3.0)
            Schedule(3.0, "StopDrunkTalk" )
            Say("BB Torres", "But people vanished in these mountains", 5.0)

        elseif self.ValleyTalk == 2 then
            self.ValleyTalk = 3
            self.MaidenUnlocked = true

            DrunkMan.StartTalk()
            Say("BB Torres", "Nothing stays a rumor here", 4.0)
            Say("BB Torres", "A man disappears, people search", 4.0)
            Say("BB Torres", "A girl falls from a cliff, people whisper", 4.0)
            Say("BB Torres", "Give it enough years and they throw a festival", 5.0)
            DrunkMan.StopTalk()

        else
            local ValleyTalk = {
                "Some roads are shorter at night",
                "The Antares rises sometimes even without rain",
                "Dogs here bark at empty roads",
                "People say mountains don't move\nPeople don't watch mountains",
                "Can't explain this place\nYou won't understand",
                "Never follow lights into the woods\nEspecially polite ones"
            }

            SetState("DrunkMan", "DrunkIdle")
            Say("BB Torres", ValleyTalk[math.random(#ValleyTalk)], 5.0)
        end

        self.Talk() --self.TalkPlace()
    end


    -- LUA VERMELHA
    function self.TalkFestival()
        if not self.FestivalCompleted then
            self.FestivalCompleted = true
            DrunkMan.StartTalk()
            Say("BB Torres", "Masks, drums and bad judgment", 4.0)
            Say("BB Torres", "I'm a Christian man, Thiago", 4.0)
            Say("BB Torres", "Not a particularly successful one", 4.0)
            Schedule(2.0, "StopDrunkTalk" )
            Schedule(2.5, "SetState", "DrunkMan", "DrunkIdle")
            Say("BB Torres", "But I recognize a cult", 3.0)
            Say("Thiago", "You think that carnival is a cult?", 4.0)

            DrunkMan.StartTalk()
            Say("BB Torres", "Long time ago, We used to heard noises in the valley", 4.0)
            Say("BB Torres", "and shadows dancing under the red moon", 5.0)
        end

        DrunkMan.StartTalk()
        Say("BB Torres", "Now people are starting to wear masks and dance with them", 4.0)
        Say("BB Torres", "We should be careful with unknown symbols", 5.0)
        DrunkMan.StopTalk()

        self.Talk()
    end


    -- MISSING MAN
    function self.TalkMissing()
        if not self.MissingCompleted then
            self.MissingCompleted = true
            self.FamilyUnlocked = true

            DrunkMan.StartTalk()
            Say("BB Torres", "A farmhand, last week", 3.0)
            Say("BB Torres", "Walked home and never arrived", 4.0)
            Say("BB Torres", "Police searched, farmers searched", 4.0)
            Say("BB Torres", "The dogs returned", 3.0)
            DrunkMan.StopTalk()

            SetState("DrunkMan", "DrunkIdle")
            Say("Thiago", "And the man?", 2.0)

            DrunkMan.StartTalk()
            Say("BB Torres", "People disappear, Thiago", 4.0)
            Say("BB Torres", "It's always the same", 2.0)
            Schedule(1.5, "StopDrunkTalk" )
            Schedule(2.0, "SetState", "DrunkMan", "DrunkIdle")

            Say("BB Torres", "My father used to say...", 3.0)
            Say("BB Torres", "...", 2.0)
            Say("Thiago", "Your father used to say what?", 4.0)
        end

        DrunkMan.StartTalk()
        Say("BB Torres", "Nothing", 2.0)
        Schedule(1.5, "StopDrunkTalk" )
        Schedule(2.0, "SetState", "DrunkMan", "DrunkIdle")
        Say("BB Torres", "Ask me something else", 3.0)

        self.Talk()
    end


    -- FALLING MAIDEN
    function self.TalkMaiden()
        if not self.MaidenCompleted then
            self.MaidenCompleted = true

            DrunkMan.StartTalk()
            Say("BB Torres", "Old tale from Morro Espreitador", 4.0)
            Say("BB Torres", "A young girl walked into the woods", 4.0)
            Say("BB Torres", "Three days later she came walking back", 4.0)
            Say("BB Torres", "Alive... briefly", 3.0)
            Schedule(3.0, "StopDrunkTalk" )
            Schedule(4.0, "SetState", "DrunkMan", "DrunkIdle")
            Say("BB Torres", "Then she threw herself from the overlook", 5.0)
            Schedule(2.0, "StopDrunkTalk" )        
            Say("Thiago", "Who was she?", 3.0)
        end

        DrunkMan.StartTalk()
        Say("BB Torres", "Depends who you ask", 3.0)
        Schedule(2.5, "StopDrunkTalk" )
        Schedule(3.0, "SetState", "DrunkMan", "DrunkIdle")
        Say("BB Torres", "Depends even more on who is listening", 4.0)
        
        self.Talk()
    end


    -- SCHWARZ FAMILY
    function self.TalkSchwarz()
        self.Finished = true

        Say("Thiago", "What's up with the Schwarz family?", 4.0)
        SetState("DrunkMan", "DrunkIdle")
        Say("BB Torres", "...", 2.0)
        DrunkMan.StartTalk()
        Say("BB Torres", "Different question", 3.0)
        DrunkMan.StopTalk()

        Say("Thiago", "I'm staying at their fazenda", 4.0)
        SetState("DrunkMan", "DrunkTalk")
        Shake("DrunkMan", 20.0, 1.5)
        Say("BB Torres", "What...", 3.0)
        DrunkMan.StartTalk()

        Say("BB Torres", "How many nights?", 3.0)
        Say("Thiago", "Why? Does it matter?", 3.0)
        DrunkMan.StartTalk()
        Schedule(1.5, "StopDrunkTalk" )
        Schedule(2.0, "SetState", "DrunkMan", "DrunkIdle")
        Schedule(3.0, "SetState", "DrunkMan", "DrunkShut")

        Say("BB Torres", "Such a lucky strike", 3.0)
        DrunkMan.StartTalk()
        Say("BB Torres", "There's an old story here in Capao seco", 3.0)
        Say("BB Torres", "It's the valley's family", 3.0)
        Schedule(1.5, "StopDrunkTalk" )
        Schedule(2.0, "SetState", "DrunkMan", "DrunkIdle")
        Say("BB Torres", "Here before the roads\nBefore the church", 4.0)

        Say("Thiago", "That doesn't make sense", 3.0)
        
        DrunkMan.StartTalk()
        Say("BB Torres", "The horror can't be understood", 4.0)
        Say("BB Torres", "Everything wrong here has a harmless name", 5.0)
        Say("BB Torres", "Madness, suicide, missing", 3.0)
        Say("BB Torres", "Animal attacks, festival", 3.0)
        DrunkMan.StopTalk()

        Say("Thiago", "What are you trying to tell me?", 4.0)

        DrunkMan.StartTalk()
        Say("BB Torres", "Leave", 2.0)
        Say("BB Torres", "Take your medicine boxes", 3.0)
        Say("BB Torres", "Drive until the mountains look small behind you", 5.0)

        Schedule(1.5, "StopDrunkTalk" )
        Schedule(2.0, "SetState", "DrunkMan", "DrunkIdle")
        Say("BB Torres", "Then keep driving", 3.0)

        Shake("DrunkMan", 5.0, 6)
        SetState("DrunkMan", "DrunkIdle")
        Say("Thiago", "You're terrified", 3.0)

        DrunkMan.StartTalk()
        Say("BB Torres", "The medicine man makes a diagnosis", 4.0)
        Say("BB Torres", "Write me a prescription", 3.0)
        SetState("DrunkMan", "DrunkIdle")
        Say("BB Torres", "Two roads south, one sunrise east", 4.0)
        
        Schedule(1.5, "StopDrunkTalk" )
        Schedule(2.0, "SetState", "DrunkMan", "DrunkIdle")
        Say("BB Torres", "And never come back", 3.0)
        Schedule(1.0, "SetState", "DrunkMan", "DrunkShut")
        Say("Thiago", "...", 3.0)

        DrunkMan.StartTalk()
        Say("BB Torres", "The red moon is coming", 3.0)
        Schedule(2.0, "StopDrunkTalk" )
        Say("BB Torres", "Drink with me", 3.0)

        SetState("DrunkMan","DrunkDrinks")
        Say("BB Torres", "To roads", 2.0)
        Shake("DrunkMan", 5.0, 6)
        Say("Thiago", "To roads", 2.0)
        SetState("DrunkMan","DrunkSleept")
        Say("BB Torres", "May yours remember..\nwhich way is out", 5.0)
        Say("BB Torres", "...", 3.0)
        self.NightComing()

        self.TalkFinished()
    end

    function self.NightComing()
        SetState("BarInBG","BarInNight")
        SetState("Bar","BarOutNight")
        SetState("HospitalOutBG","HospitalNight")
        SetState("Tunnel","TunnelNight")

        SetState("Fountain","FountainNight")
        SetState("PlazaReturn","ReturnNight")
        SetState("PlazaPan","PlazaPanThug")
        SetState("PlazaExit","PlazaExitNight")
        --SetState("LupertaStatueBG","FountainNight")
    end

    -- FINISHED
    function self.TalkFinished()
        Choice( { "Check if he's alive", function()
            self.CheckedAlive = true
            Say("Thiago", "BB...?", 2.0)
            Say("Thiago", "...He's breathing", 3.0)
            Say("Thiago", "Completely passed out", 3.0)
            self.TalkFinished()
        end },

        { self.CheckedAlive, "End conversation", function() 
            Say("Thiago", "I think have heard enough for one night", 4.0) Say() 
        end }
        )

    end

    -- ENTITY CALLBACKS
    function self.OnOpenTalk()
        self.TalkOpened = true
        Say("Old Drunk", "Hey, that was unexpected, thanks!", 4.0)
        Say("Old Drunk", "You're not from here, are you?", 4.0)
        SetState("DrunkMan", "DrunkIdle")
        Say("Thiago", "Is it that obvious?", 3.0)
        DrunkMan.StartTalk()
        Say("Old Drunk", "You bought a stranger a beer", 4.0)
        Say("Old Drunk", "Locals know better", 3.0)
        DrunkMan.StopTalk()
        SetState("DrunkMan", "DrunkIdle")

        self.Talk()
    end

    function self.OnInteract()
        if not self.Invite then
            StartSequence( function() Say("\n...", 3.0) Say() end )
        elseif self.Finished then
            StartSequence(self.TalkFinished)
        end
    end

    function self.OnLookComment()
        if self.Finished then
            Say("\nBB is completely unconscious", 4.0)
        elseif not self.Invite then
            Say("\nHe doesn't look open to talk", 4.0)
            Say("\nMaybe something to drink can loosen him up a bit", 5.0)
        else
            Say("\nHe seems friendlier now", 3.0)
        end

        Say()
    end

    function self.OnLook()
        StartSequence(self.OnLookComment)
    end

    return self
    end)()

    }, -- Conversation HANDLE



    { Quad = { OnConstruct = function() return { NameId = "ReturnToBarInside", Cursor = "MDown", Pos = { x = 0, y = 370 }, 
        Size = { Width = 920, Height = 140 }} end, OnInteract = function() SwipeScene("BarInside", "Up") end } 
    }, -- Return to bar

    { DrunkMan = (function() 
        local self = { 
            Invite = false, 
            Sleeping = false, 
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
            return { Textures = {
                {DrunkStart = "data/Scenes/Town/BBThinkingEmpty.jpg"},
                {DrunkIdle = "data/Scenes/Town/BBThinking.jpg"},
                {DrunkHappy = "data/Scenes/Town/BBHappy.jpg"}, 
                {DrunkShut = "data/Scenes/Town/BBA.jpg"}, 
                {DrunkTalk = "data/Scenes/Town/BBB.jpg"}, 
                {DrunkDrinks = "data/Scenes/Town/BBFondo.jpg"},
                {DrunkSleept = "data/Scenes/Town/BBHecho.jpg" }
            }, CurrentID = "DrunkStart"
        }
            
        end

        function self.StartTalk()
            if self.TalkAnimID == 0 then
                SetState("DrunkMan", "DrunkTalk")
                self.TalkAnimID = ScheduleRepeat(0.15, "AnimateDrunkTalk", "CancelDrunkTalk")
            end
        end

        function self.StopTalk()
            if self.TalkAnimID ~= 0 then
                CancelScheduled(self.TalkAnimID)
                self.TalkAnimID = 0
            end

            SetState("DrunkMan", "DrunkShut")
        end

        function AnimateDrunkTalk()
            if self.TalkCount <= self.TalkAmount and self.TalkFrame == 0 then
                SetState("DrunkMan", "DrunkTalk")
                self.TalkFrame = 1
            else
                SetState("DrunkMan", "DrunkShut")
                self.TalkFrame = 0
            end

            self.TalkCount = self.TalkCount + 1

            if self.TalkCount > self.QuietAmount then
                self.TalkCount = 0
                self.TalkAmount = math.random(self.TalkTimeMin, self.TalkTimeMax)
                self.QuietAmount = math.random(self.QuietTimeMin, self.QuietTimeMax)
            end
        end

        return self
        end)()
    } -- DRUNK MAN BACKGROUND
    


}

return {
    { Entity = "GuestRoom", Textures = { GuestRoom = "data/Scenes/Mansion/RoomGuest.jpg"} },

    --[[
    { CarKey = (function() local self = {}
        function self.OnConstruct() return {NameView = "Car Keys", Textures = "data/Scenes/Inventory/CarKeys.png", Visible = false } end
        function self.OnLookComment()
            Say("\nMy car keys\nThe keyring is a Sunhouse gift", 4.0)
            Say()
        end
        function self.OnLook() StartSequence(self.OnLookComment) end
        return self
        end)() 
    }, -- Car Keys
    ]]--

    { Wallet = (function() local self = {}
        function self.OnConstruct() return { Textures = "data/Scenes/Inventory/Wallet.png", Visible = false } end
        function self.OnLookComment()
            Say("\nMy Wallet,\nInside is my ID and a few bucks", 4.0) 
            Say("\nBesides that, it's empty as always", 3.0) 
            Say()
        end
        function self.OnLook() StartSequence(self.OnLookComment) end
        return self
        end)() 
    }, -- Wallet

    { Phone = (function() local self = {}
        function self.OnConstruct() return { Textures = "data/Scenes/Inventory/BrokenPhone.png", Visible = false } end
        function self.OnBrokenComment()
            Say("\nOh no... It's totally dead!", 3.0) 
            Say("\nMy phone is broken and useless", 3.0) 
            Say()
        end
        function self.OnLook() StartSequence(self.OnBrokenComment) end
        return self
        end)() 
    }, -- Phone

    { IntroWakeup = (function()
        local self = { TotalItems = 0 }
        function self.OnConstruct()
        return { 
            Clickable = false, 
            Textures = { 
                { IW1 = "data/Scenes/Mansion/WakeEyes.jpg"}, 
                { IW2 = "data/Scenes/Mansion/WakeUp.jpg"}, 
                { IW3 = "data/Scenes/Mansion/RoomInjury.jpg"}, 
                { IW4 = "data/Scenes/Mansion/DoorKnock.jpg"} 
            } 
        }
        end

        function self.OnInit()
            self.OnEnter()
        end

        function self.OnEnter()
            self.OnIntroStart()
        end

        function self.OnIntroStart()
            SetThunder(true)
            SetNoise(false)

            SetAlpha("Dark", 1)
            SetVisible("Dark", true)

            SetAlpha("Shade", 0)
            SetVisible("Shade", true)

            Schedule( 4, "TriggerThunder", 2)
            Schedule( 5, "Fade", "Dark", 0.0, 2.0)

            Schedule( 6.5, "TriggerThunder", 3)
            Schedule( 7, "SetState", "IntroWakeup", "IW2")
            Schedule( 7, "SetNoise", false)

            Schedule( 8.0, "Fade", "IntroWakeup", 0.0, 10.0)
            Schedule( 8.1, "ShowTitle", "MAD WORLD", 7, 64.0,  320, 140, 255, 255, 255, 64)
            StopMusic()

            Schedule( 15.0, "SetThunder", false)
            Schedule( 16.0, "StartSequence", "MoreIndications")
            Schedule( 17.0, "SetInventory", true)

            Schedule( 15.0, "Fade", "Shade", 0.45, 4)
            SetShadeAlpha( 0 )          -- Use custom Shade
        end

        function MoreIndications()
            SetThunder(false)
            Say("\n Ohh What the heck", 3.0)
            Say("\n How did I get here??", 3.0)
            Say("\n And where's all my stuff?")

            self.SetItemsInScene(true)
        end

        function self.CountItem()
            if self.TotalItems <= 2 then
                self.TotalItems = self.TotalItems + 1
            end

            if self.TotalItems == 2 then
                self.SetItemsInScene(false)
                print("Called Injury event")
                        
                SetAlpha("Shade", 0)
                StartSequence(self.OnDoorKnocking)
                SetState("IntroWakeup", "IW3")
                SetVisible("IntroWakeup")
                Shake("IntroWakeup", 32.0, 1.0)
                Fade("IntroWakeup", 1.0, 1.0)
            end

            return self.TotalItems
        end

        function self.SetItemsInScene(clickable)
            SetClickable("Tapiz", clickable)
            SetClickable("vestidor", clickable)
            SetClickable("GuestBed", clickable)
            SetClickable("PaintA", clickable)
            SetClickable("HideDoorA", clickable)
            SetClickable("LBedTable", clickable)
            SetClickable("RBedTable", clickable)
            SetClickable("GuestWindow", clickable)
        end

        function self.OnDoorKnocking()
            SetEmotion()
            Say("\n\nOoouch!", 3.0)
            SetShadeAlpha(.65)
            Wait(1)

            Say("Damn my leg... it hurts", 3.0)
            Say("What happened yesterday?\ncan't think straight with this Noggin ache", 6.0)
            Say("I don't remember about anything at all", 4.0)
            Say("Well I guess is not that bad, I can walk fine...", 5.0)
            Say("But I'll have to check it later", 4.0)

            Wait(1.0)
            SetState("IntroWakeup", "IW4")
            Say("'Knock Knock'", 3.0)
            SetEmotion("TWorry")
            Say("...Now what?", 3.0)
            Say("Someone is knocking at the door..", 4.0)
            
            SetEmotion("TNeutral")
            Say("Who is it?", 3.0)
            Say("Girl","Hello sir, are you awake!?", 4.0)
            SetEmotion("TSuspect")
            Say("It's a young woman...", 3.0)
            Say("Girl","Please answer me, are you awake??", 4.0)

            SetEmotion("TSurprise")
            Say( "Girl","Otherwise, we'll need to force the door down\nsince you might be unconscious, dead or something!", 9.0)
            SetEmotion("TNeutral")
            Say("Hey, wait yes, I'm awake!", 4.0)
            SetState("Ada","ASmile") SetAlpha("Ada", 0.0) SetVisible("Ada")
 
            SetEmotion("T4Wall")
            Say("Girl","Oh so, you can talk, that's good!", 3.0)
            SetEmotion("TNeutral")
            Say("Girl","Alright Sir, Do you want to open the door?\nSo We can properly introduce ourselves..", 7.0)
            Say("Sure, just give me a sec", 3.0)

            Fade("Ada", 1.0, 3)
            Say("Hello hello\nSorry for the rush but you slept all morning..", 6)
            Ada.StartTalk()
            SetEmotion("TSurprise")
            Say("Ada", "Well, I'm Ada\nDo you have a name?", 5)

            Ada.StopTalk()
            SetEmotion("TSmile")
            Say("Thiago", "I'm Thiago Veira, Nice to meet you Ada", 5)
            Ada.StartTalk()
            SetEmotion("TNeutral")
            Say("Ada", "You must feel quite confussed right now", 3)
            Say("Ada", "Let me help you with a bit of context", 4)

            MansionView.AnimatePan()
            Fade("MansionView", 1.0, 5)
            Say("Ada", "We're in the Schwarz Fazenda, a huge agricultural company...", 5)
            SetCurrentScene("HallwayInit")
            Say("Ada", "Located inside the capao seco woods", 4)
            SetVisible("Ilsa")
            Ada.StopTalk()
            Say("Ada", "Somewhere between the mountains of espretador valley", 5)

            Wait(4)
            Fade("MansionView", 0, 7)
            Wait(4)
            SetEmotion("TPeace")
            Ada.StartTalk()
            Say("Ada", "And this is my mother, Ilsa Schwarz\nThe family head and main administrator of family busisness", 9)
            Ada.StopTalk()

            Say("Thiago", "Hi, nice to meet you Ms Schwarz", 3)
            Ilsa.StartTalk()
            SetEmotion("TNeutral")
            Say("Ilsa", "Hey Are you Ok? How do you feel? ", 5)
            SetEmotion("TSuspect")
            Say("Ilsa", "We found you yesterday laying unconscious in the floor\n you really scared us", 7)

            Ilsa.StopTalk()
            SetEmotion("TNeutral")
            Say("Thiago", "Yes Well, thanks for your care\nto be honest I don't remember anything at all", 7)
            Say("Thiago", "Frankly, I was hoping you to explain me what really happened", 5)
            Ilsa.StartTalk()

            Say("Ilsa", "I guess you were so tired that just felt asleep", 4)
            Say("Ilsa", "And how is your leg? I'm affraid You'll need to see a doctor", 5)
            Say("Ilsa", "Ada, please guide our guest to the town's path\nso He can go to the hospital", 6)
            Ilsa.StopTalk()

            SetState("Ada","AAprove")
            Say("Ada", "Yep sure", 3) Ada.StopTalk() Ilsa.StartTalk()
            Say("Ilsa", "Mind you, I wish We could continue talking\nbut I've duties and urgencies to attend", 6)
            Say("Ilsa", "Sorry, I've a meeting with a couple of officers'..", 4)
            Ilsa.StopTalk()

            Ada.StartTalk()
            Say("Ada", "Ok, see you later mother", 4)
            Fade("Ilsa", 0.0, 2)
            Move("Ilsa", -256)
            Ada.StopTalk()
            Wait(2)

            Ada.StartTalk()
            Say("Ada", "So, Let's continue with this onboarding...", 4)
            Say("Ada", "We're in the main hallway\nAll rooms are connected to this gallery hub", 6)
            Say("Ada", "Now follow me I'll take you to the Lobby", 5)
            Ada.StopTalk()

            LobbyInit.GoRight()
            Fade("Dark", 1, 3)
            Wait(false)
            SetEntityScene("Ada", "Lobby")
            SetCurrentScene("Lobby")
            Wait(2.5, false)

            Fade("Dark", 0, 3)
            Wait(false, 3.5)
            Ada.StartTalk()
            Say("Ada", "So here is where we found you last night, no recalls yet?", 4)
            Say("Ada", "Give it a look around\nand when you're done talk with me to continue", 6)
            Ada.StopTalk()
            Say("Thiago", "Alright")
            Say()
            SetClickable("Ada")
        end

        function self.OnExit()
            Fade("Shade", 0.0, 0.3)
            SetShadeAlpha( 0.65 )       -- Enable auto shade 0.35
        end

        return self
        end)()
    },


    
    { Quad = (function() 
        local self = {}
        function self.OnConstruct() return { NameId = "Tapiz", NameView = "Tapestry", Pos = { x = 45, y = 80 }, Size = { Width = 160, Height = 280 }, Clickable = false} end
        function self.OnCommentEntry() Say("\nI don't want to touch that\n It's full of dust", 4.0) Say() end
        function self.OnCommentLook() 
            if IntroWakeup.TotalItems < 2 then
                Say("\nI've no time for that,\n I need to search my wallet and cellphone", 5.0) 
            else
                Say("\nIt's just a room decoration", 3.0) 
            end
        Say() 
        end
        function self.OnInteract()
            StartSequence(self.OnCommentEntry) 
        end 

        function self.OnLook() StartSequence(self.OnCommentLook) end 
        return self
        end)()
    }, -- TAPIZ

    { Quad = (function() 
        local self = {}
        function self.OnConstruct() return { NameId = "vestidor", NameView = "Dresser", Pos = { x = 284, y = 232 }, Size = { Width = 70, Height = 105 }, Clickable = false} end
        function self.OnCommentEntry() Say("\nThere's just a bunch of old socks and sheets", 4.0) Say() end
        function self.OnCommentLook() Say("\nA big dresser with a bunch of drawers, nothing important inside", 4.0) Say() end
        function self.OnInteract() StartSequence(self.OnCommentEntry) end
        function self.OnLook() StartSequence(self.OnCommentLook) end 
        return self
        end)()
    },  -- DRESSER

    { Quad = (function() local self = {}
        function self.OnConstruct() return { NameId = "LBedTable", NameView = "Left Bedside table", Pos = { x = 366, y = 276 }, 
            Size = { Width = 35, Height = 55 }, Clickable = false} end
        function self.OnCommentLook() Say("\nAn empty bedside table", 3.0) Say() end
        function self.OnInteract() 
            StartSequence(self.OnCommentLook) 

        end      
        function self.OnLook() 
            StartSequence(self.OnCommentLook) 
        end
        return self
        end)()
    }, -- LBedTable

    { Quad = (function() local self = {}
        function self.OnConstruct() return { NameId = "RBedTable", NameView = "Right Bedside table", Pos = { x = 562, y = 264 }, 
            Size = { Width = 40, Height = 65 }, Clickable = false} end
        function self.OnCommentEntry() Say("\nThe drawer is empty", 3.0) Say() end
        function self.OnWalletFound() 
            PickUp("Wallet", 2)
            Say("\nHey here's my wallet...\ngood to know I haven't lost it", 5.0) 
            Say("",0.5)
            IntroWakeup.CountItem()
        end
            
        function self.OnCommentLook() Say("\nA bedside table with one small drawer", 4.0) Say() end
        function self.OnInteract()

            if not IsEntityInScene("Wallet", "Inventory") then
                StartSequence(self.OnWalletFound)
                --PickUp("Wallet")
                --if IntroWakeup.CountItem() == 2 then return end
                --ShowInventory(2)
                
            else
                StartSequence(self.OnCommentEntry)
            end
        end

        function self.OnLook() StartSequence(self.OnCommentLook) end 
        return self
        end)()
    }, -- RBedTable

    { Quad = (function() local self = {}
        function self.OnConstruct() return { NameId = "GuestBed",  NameView = "Bed", Pos = { x = 405, y = 226 }, Size = { Width = 158, Height = 143 }, Clickable = false} end
        function self.OnCommentEntry() Say("\nI don't want to go back there\nI've rested enough.", 5.0) Say() end
        function self.OnPhoneFound()
            Say("\nLet me bend down to see what's underneath the bed...", 5.0) 
            PickUp("Phone", 2)
            Say("\nHey my phone is here!", 3.0)
            Say("",0.5)
            IntroWakeup.CountItem()
        end
        function self.OnCommentLook() Say("\njust a normal bed, nothing more", 3.0) Say() end
        function self.OnInteract()
            StartSequence(self.OnCommentEntry) 
        end 
                
        function self.OnLook()
            if not IsEntityInScene("Phone", "Inventory") then
                StartSequence(self.OnPhoneFound)
            else
                StartSequence(self.OnCommentLook) 
            end
        end 
        return self
        end)()
    },  -- BED

    { Quad = (function() 
        local self = {}
        function self.OnConstruct() return { NameId = "PaintA", NameView = "Floresta\npaint", Pos = { x = 760, y = 107 }, Size = { Width = 148, Height = 138 }, Clickable = false} end
        function self.OnCommentEntry() Say("\nNothing to do with that", 3.0) Say() end
        function self.OnCommentLook()
            if IntroWakeup.TotalItems < 2 then
                Say("\nI've no time for that,\n I need to search my wallet and cellphone", 5.0)
            else
                Say("\nA nice painting of the mato grosso\nArt style is fine, A bit generic maybe", 5.0)
            end
            Say() 
        end
        function self.OnInteract() StartSequence(self.OnCommentEntry) end function self.OnLook() StartSequence(self.OnCommentLook) end 
        return self
        end)()
    },  -- PAINTING

    { Quad = (function() 
        local self = {}
        function self.OnConstruct() 
            return { NameId = "HideDoorA", NameView = "Hidden Door", Position = { x = 90, y = 360 }, Size = { Width = 100, Height = 85 }, Clickable = false}
        end
        function self.OnInteractComment() Say("\nSeems it's locked from the other side", 3.0) Say() end
        function self.OnLookComment() Say("\nOhh there's a hidden door behind the tapestry", 4.0) Say() end
        function self.OnInteract() StartSequence(self.OnInteractComment) end function self.OnLook() StartSequence(self.OnLookComment) end
        return self
        end)()
    }, -- SECRET DOOR
        
    { Quad = (function() 
        local self = {}
        function self.OnConstruct() 
            return { NameId = "GuestWindow",  NameView = "Window", Pos = { x = 425, y = 120 }, Size = { Width = 108, Height = 90 }, Clickable = false} end
        function self.OnCommentEntry() Say("\nSo finally we have a sunny day.", 3.0) Say() end
        function self.OnCommentLook() Say("\nOutside, there's a dense forest \nthat fades into the mountains in the distance.", 6.0) Say() end
        function self.OnInteract() StartSequence(self.OnCommentEntry) end function self.OnLook() StartSequence(self.OnCommentLook) end 
        return self
        end)()
    }, -- WINDOW

    --[[
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
    ]]

}
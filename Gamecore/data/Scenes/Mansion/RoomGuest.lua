return {
    { Entity = "GuestRoom", Textures = { GuestRoom = "data/Scenes/Mansion/RoomGuest.jpg"} },

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
            if self.TotalItems <= 3 then
                self.TotalItems = self.TotalItems + 1
            end

            if self.TotalItems == 3 then
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
        end

        function self.OnDoorKnocking()
            SetEmotion()
            Say("\n\nOoouch!", 3.0)
            Say()
            SetShadeAlpha(.65)

            Say("Damn my leg... it hurts", 3.0)
            Say("What happened yesterday!?", 3.0)
            Say("I don't remember about anything at all", 4.0)

            Say("Well I guess is not that bad", 4.0)
            Say("I think can walk...", 4.0)
            Say("But I'll need to check a doctor later", 4.0)

            Say()
            SetState("IntroWakeup", "IW4")
            Say("'Knock Knock'", 3.0)
            
            SetEmotion("TWorry")
            Say("...Now what?", 3.0)
            Say("Someone is knocking at the door..", 4.0)
            
            SetEmotion("TNeutral")
            Say("Who is it?", 3.0)
            Say( "Femenine voice","Hello sir, are you awake!?", 4.0)
            
            SetEmotion("TSuspect")
            Say("...", 3.0)
            Say("It's a woman...", 3.0)
            Say( "Femenine voice","Please answer me, are you awake??", 4.0)
            
            SetEmotion("TSurprise")
            Say( "Femenine voice","Otherwise, we'll need to force the door down\nsince you might be unconscious, dead or something!", 9.0)
            SetEmotion("TNeutral")
            Say("Hey, wait yes, I'm awake!", 4.0)
           
            SetEmotion("T4Wall")
            Say( "Femenine voice","Oh so, you can talk, that's good!", 3.0)
            Say( "Femenine voice","Ok Sir, Can you tell me what's your name then?", 4.0)
            
            SetEmotion("TPeace")
            Say("Ah yes, I'm Thiago Veira")
            Say( "Femenine voice","Oh hello Mister Thiago Veira then!", 4.0)
            Say("Thiago" ,"Just call me Thiago please", 3.0)

            SetEmotion("TNeutral")
            Say( "Femenine voice","Alright Thiago, Do you want to open the door?", 5.0)
            Say("Thiago" ,"Sure, just give me a sec", 3.0)
            Say()
            BlendScene("HallwayInit")

        end

        function self.OnExit()
            -- SetAlpha("Shade", 0.0)      -- 
            Fade("Shade", 0.0, 0.3)
            SetShadeAlpha( 0.35 )       -- Enable auto shade
        end

        return self
        end)()
    },


    
    { Quad = (function() 
        local self = {}
        function self.OnConstruct() return { NameId = "Tapiz", NameView = "Tapestry", Pos = { x = 45, y = 80 }, Size = { Width = 160, Height = 280 }, Clickable = false} end
        --function self.OnCommentEntry() Say("/nCacho", "I don't want to touch that\n It's full of dust", 4.0) Say() end
        function self.OnCommentEntry() Say("\nI don't want to touch that\n It's full of dust", 4.0) Say() end
        function self.OnCommentLook() Say("\nIt's just a room decoration", 3.0) Say() end
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
        function self.OnCommentEntry() Say("\nThe dresser is empty", 3.0) Say() end
        function self.OnWalletFound() Say("\nHey here's my wallet...\ngood to know I haven't lost it", 5.0) Say() end
        function self.OnCommentLook() Say("\nA big dresser with a bunch of drawers", 3.0) Say() end
        function self.OnInteract()
            if not IsEntityInScene("Wallet", "Inventory") then
                --PickUp("Wallet", 2)
                
                PickUp("Wallet")
                if IntroWakeup.CountItem() == 3 then return end
                ShowInventory(2)
                
                StartSequence(self.OnWalletFound)
            else
                StartSequence(self.OnCommentEntry)
            end

        end
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
        function self.OnCommentFound() Say("\nNice, Found my car keys", 3.0) Say() end
        function self.OnCommentLook() Say("\nA bedside table with one small drawer", 4.0) Say() end
        function self.OnInteract()

            if not IsEntityInScene("CarKey", "Inventory") then
                PickUp("CarKey")
                
                if IntroWakeup.CountItem() == 3 then return end
                ShowInventory(3)
                StartSequence(self.OnCommentFound) 
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
        function self.OnPhoneFound() Say("\nHey my phone is under the bed", 3.0) Say() end
        function self.OnCommentLook() Say("\njust a normal bed, nothing of interest", 3.0) Say() end
        function self.OnInteract()
            StartSequence(self.OnCommentEntry) 
        end 
                
        function self.OnLook()
            if not IsEntityInScene("Phone", "Inventory") then
                
                PickUp("Phone")
                if IntroWakeup.CountItem() == 3 then return end
                ShowInventory(3)
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
        function self.OnCommentLook() Say("\nA nice painting of the mato grosso\nArt style is fine, A bit generic maybe", 5.0) Say() end
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
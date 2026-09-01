return {
    { Entity = "BarInBG", Textures = {
        {BarInDay = "data/Scenes/Town/BarInDay.jpg"},
        {BarInNight = "data/Scenes/Town/BarInNight.jpg"}}
    },
    
    { Quad = { OnConstruct = function() return { NameId = "ReturnToBarOut", Cursor = "MUp", Pos = { x = 620, y = 70 },
        Size = { Width = 130, Height = 170 }} end, OnInteract = function() SwipeScene("BarOutside", "Down") end }
    },

    { Lighter = { OnConstruct = function() return { Pos = { x = 820, y = 335 }, NameView = "Lighter", 
        Textures = { {LighterMini = "data/Scenes/Inventory/LighterMini.png"}, 
            {Lighter = "data/Scenes/Inventory/Lighter.png"} }, CurrentID = "LighterMini" } end,
        --OnEnter = function() if IsEntityInScene("Matches", "Inventory") then RemoveEntity("Lighter") end end, 
        OnInit = function() 
            if IsEntityInScene("Matches", "Inventory") then RemoveEntity("Lighter") end
        end,
        OnInteract = function() PlaySound("Great") PickUp("Lighter", 2) SetState("Lighter", "Lighter") end,
        OnLook = function() 
            StartSequence( 
                function() 
                    if not IsEntityInScene("Lighter", "Inventory") then 
                        Say("Someone left an old lighter", 3.0) 
                    else
                        Say("An old lighter", 3.0) Say() 
                    end
                    Say() 
                end
            ) 
        end} 
    },  -- LIGHTER

    { Quad = { OnConstruct = function() return { NameId = "Drunk guy", Pos = { x = 780, y = 130 }, Size = { Width = 140, Height = 165 }} end,
        OnInit = function() 
            if not IsEntityInScene("Wallet", "Inventory") then 
                Schedule(1.0, "PickUp", "Wallet")  -- ATTENTION HERE - ONLY FOR TESTING - REMOVE AFTER USE
            end 
        end, 
        OnInteract = function() SwipeScene("BarDrunk", "Down") end,
        OnLook = function() StartSequence( function() Say("A middle-aged man who appears to be drinking alone.", 5.0) Say() end) end}
    },

    { Quad = { OnConstruct = function() return { NameId = "Random Woman", 
        Pos = { x = 362, y = 109 }, Size = { Width = 28, Height = 169 }} end, 
        OnInteract = function() StartSequence( function() Say("Woman","Sorry, I don't know you", 3.0) Say() end) end, 
        OnLook = function() StartSequence( function() Say("She's talking with the bartender", 5.0) Say() end) end} 
    },

    { Entity = "Beer", Position = { x = 920, y = 0 }, Textures = "data/Scenes/Inventory/BeerPint.png", Clickable = true},

    { Quad = { OnConstruct = function() return { NameId = "Bartender", 
        Pos = { x = 270, y = 101 }, Size = { Width = 51, Height = 72 }} end,
        OnInteract = function() 
            if GetFlag("DrunkSlept") then
                StartSequence( function() 
                    Say("Thiago","Hey, that man over there just fainted", 4.0) 
                    Say("Bartender","Ah, He's fallen asleep again. He always does that.", 5.0) 
                    Say("Bartender","Don't worry, just leave him there", 4.0) Say() 
                end) 
            else
                StartSequence( function() Say("Bartender","Hello sir, The pint of beer costs 5 bucks", 5.0) Say() end) 
            end
        end, 
        OnLook = function() StartSequence( function() Say("He's working while talks with the woman", 5.0) Say() end) end,
        OnInit = function() StopBirds() PlayMusic("Bar")  end,
        OnEnter = function() StopBirds()  if not GetFlag("DrunkSlept") then PlayMusic("Bar") end end,
        OnCombine = function(itemId) 
            if itemId == "Wallet" and not IsEntityInScene("Beer", "Inventory") and not GetFlag("DrunkInvited") then 
                print("Found Beer")
                PlaySound("Great")
                StartSequence( function() Say("Here's you pint sir, keep the change") end)
                PickUp("Beer",1)
            end
        end
        }
    },

    { Quad = { OnConstruct = function() return { NameId = "DudeRight", NameView = "Bunch of dudes",
        Pos = { x = 121, y = 89 }, Size = { Width = 94, Height = 151 }} end, 
        OnInteract = function() StartSequence( function() Say("...", 3.0) Say() end) end, 
        OnLook = function() StartSequence( function() Say("They've no interest in answering you", 5.0) Say() end) end} 
    },

    { Quad = { OnConstruct = function() return { NameId = "DudeLeft", NameView = "Bunch of dudes", 
        Pos = { x = 1, y = 55 }, Size = { Width = 77, Height = 340 }} end, 
        OnInteract = function() StartSequence( function() Say("Old man","Hey mind your own busisness?", 3.0) Say() end) end, 
        OnLook = function() StartSequence( function() Say("Everyone here is indifferent;\nperhaps that other lonely man is kinder.", 7.0) Say() end) end} 
    }


}
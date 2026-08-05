return {

    { Bandage = { OnConstruct = function() return { Textures = "data/Scenes/Inventory/Bandage.png" } end, 
        OnCombine = function(itemId) 
            if itemId == "Alcohol" then
                PickUp("Molotov", 2) 
                RemoveEntity("Bandage") 
                RemoveEntity("Alcohol")
            end 
        end,
        OnLook = function() StartSequence(function() Say("A bandage for injuries", 3.0) Say() end) end } 
    }, -- BANDAGES

    { Alcohol = { OnConstruct = function() return { Textures = "data/Scenes/Inventory/Alcohol.png" } end, 
        OnCombine = function(itemId) 
            if itemId == "Bandage" then
                PickUp("Molotov", 2) 
                RemoveEntity("Alcohol") 
                RemoveEntity("Bandage") 
            end 
        end,
        OnLook = function() StartSequence(function() Say("a bottle of ethyl alcohol", 3.0) Say() end) end } 
    }, -- ALCOHOL

    { Molotov = { OnConstruct = function() return { Textures = "data/Scenes/Inventory/Molotov.png" } end,
        OnLook = function() StartSequence( function() Say("It need some fire for ignition", 5.0) Say() end) end,
        OnCombine = function(itemId)
            if itemId == "Matches" or itemId == "Lighter" then 
                if DrunkMan.Invited then
                    StartSequence( function() Say("Thiago", "Let's hope our country never gives us a reason to use one of these", 6.0) end)
                    RemoveEntity("Molotov")
                    PickUp("MolotovFire", 2)
                else
                    StartSequence( function() Say("Thiago", "I won't do that without a reason", 4.0) end)
                end
            end
        end
        }
    }, -- MOLOTOV

    { MolotovFire = { OnConstruct = function() return { Textures = "data/Scenes/Inventory/MolotovFire.png",
        NameView = "Molotov on fire" } end,
        OnLook = function() StartSequence( function() Say("It's ready to sow chaos", 3.0) Say() end) end
        }
    }, -- MOLOTOV ON FIRE


    -- { Entity = "Med", Textures = "data/Scenes/Inventory/Medication.png", Clickable = true},

    { Doctor = { OnConstruct = function() return { NameView = "Doctor Eustaquio", Textures = "data/Scenes/Town/Medic.jpg"} end,
        OnInit = function() 
        
            StartSequence( function()
                SetEmotion("TDisabled")
                Wait(1.0)

                Say("Doctor", "Well well Mr Vera...")
                Say("Doctor", "Hmm... irregular lacerations, considerable inflammation\nand some tissue damage.", 6.0)
                Say("Doctor", "Do you remember what caused it?", 3.0)
                Say("Thiago", "Not exactly. Last night is...\na little blurry.", 4.0)

                Say("Doctor", "Curious... pronounced anisopoikilocytosis,\nwith significant erythrocyte pleomorphism.", 7.0)
                Say("Thiago", "Is that bad?", 3.0)
                Say("Doctor", "It means there's considerable morphological variation\nin your erythrocytes.", 7.0)
                Say("Doctor", "Far beyond what I would normally expect.", 4.0)

                Say("Thiago", "...I have no idea what that means.", 3.0)
                Say("Doctor", "Neither do I, ha ha...\nNot in this context.", 4.0)
                PickUp("Alcohol")
                PickUp("Bandage", 2)

                Say("Doctor", "Take this alcohol and these bandages.", 4.0)
                Say("Doctor", "Clean the wound thoroughly\nand keep it covered", 4.0)
                Say("Doctor", "And I'd suggest you seek treatment at a better-equipped hospital\nWhen you have the chance.", 7.0)
                Say("Thiago", "That's... reassuring.\nThanks, Doctor.", 4.0)

                Wait(1.0, false)
                BlendScene("HospitalOutside", 3.0)
                SetEmotion("TNeutral")
            end )

        end } 
    },
    
    --[[
    { Quad = { OnConstruct = function() return { NameId = "ReturnToHospitalOut", Cursor = "MDown", Pos = { x = 0, y = 370 }, 
        Size = { Width = 920, Height = 140 }} end, OnInteract = function() SwipeScene("HospitalOutside", "Up") end } 
    }
    ]]--

}
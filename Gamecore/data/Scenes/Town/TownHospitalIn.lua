return {

    { Bandage = { OnConstruct = function() return { Clickable = true, Textures = "data/Scenes/Inventory/Bandage.png" } end, 
        OnInteract = function() StartSequence(function() Say("I'm ok", 3.0) Say() end) end,
        OnLook = function() StartSequence(function() Say("A bandage for injuries", 3.0) Say() end) end } 
    }, -- BANDAGES

    { Alcohol = (function() 
        local self = { Combined = false, Ignited = false }
        function self.OnConstruct() return { NameId = "Alcohol", Clickable = true, Textures = {
            {Alco = "data/Scenes/Inventory/Alcohol.png"},
            {Molotov = "data/Scenes/Inventory/Molotov.png"},
            {MoloFire = "data/Scenes/Inventory/MolotovFire.png"} }, --CurrentImage = "BCopper" 
            }
        end

        function self.OnLookComment() Say("a bottle of ethyl alcohol", 3.0) Say() end
        function self.OnCombine(itemId)
            if itemId == "wick" then
            else
            end
        end

        function self.OnLook() 
            StartSequence(self.OnLookComment) 
        end

        return self
    end)()
    }, -- ALCOHOL

    -- { Entity = "Med", Textures = "data/Scenes/Inventory/Medication.png", Clickable = true},


    { Doctor = { OnConstruct = function() return { NameView = "Doctor Eustaquio", Textures = "data/Scenes/Town/Medic.jpg"} end,
        OnInit = function() 
        
            StartSequence( function() 
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
            end )

        end } 
    },
    
    --[[
    { Quad = { OnConstruct = function() return { NameId = "ReturnToHospitalOut", Cursor = "MDown", Pos = { x = 0, y = 370 }, 
        Size = { Width = 920, Height = 140 }} end, OnInteract = function() SwipeScene("HospitalOutside", "Up") end } 
    }
    ]]--

}
return {
    --{ Entity = "Med", Position = { x = 32, y = 32 }, Textures = "data/Scenes/Inventory/Medication.png", Clickable = true},
    --{ Entity = "MainKey", Position = { x = 128, y = 32 }, Textures = "data/Scenes/Inventory/MainKey.png", Clickable = true},
    --{ Entity = "PaintCan", Position = { x = 512, y = 32 }, Textures = "data/Scenes/Inventory/PaintCan.png", Clickable = true},
    -- { Entity = "Knife", Position = { x = 256, y = 32 }, Textures = "data/Scenes/Inventory/Knife.png", Clickable = true},

    --[[
    { Bullets = 
        (function() 
            local self = { Painted = false }
            function self.OnConstruct() return { NameId = "Bullets", Clickable = true, Textures = {
                {BCopper = "data/Scenes/Inventory/Bullets.png"}, {BSilver = "data/Scenes/Inventory/BulletsSilver.png"} 
            }, --CurrentImage = "BCopper" 
                }
            end

            function self.OnInteractComment() Say("\n\n I guess it's a cheap way to have silver bullets!", 4.0) Say() end
            function self.OnLookComment() Say("\n\nA couple of Real ammo bullets", 4.0) Say() end
            function self.OnCombine(itemId)
                if (itemId == "PaintCan" and self.Painted == false) then
                    self.Painted = true
                    SetState("Bullets", "BSilver")
                    StartSequence(self.OnInteractComment)
                end 
            end

            function self.OnLook() 
                StartSequence(self.OnLookComment) 
            end

            return self
        end)()
    }
    ]]--

}
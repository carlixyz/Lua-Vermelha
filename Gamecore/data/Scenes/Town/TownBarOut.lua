return {
    { Entity = "Bar", Textures = {
        {BarOutDay = "data/Scenes/Town/BarOutDay.jpg"},
        {BarOutNight = "data/Scenes/Town/BarOutNight.jpg"},
        {BarOutLua = "data/Scenes/Town/BarOutLua.jpg" }}
    },

    { Quad = { OnConstruct = function() return { NameId = "EnterBar", Cursor = "MUp", 
        Pos = { x = 100, y = 150 }, Size = { Width = 240, Height = 150 }} end, 
        OnInteract = function() 
            if IsEntityInScene("Alcohol", "Inventory") then
                SwipeScene("BarInside", "Down")
            else
                StartSequence( function() Say("I must go to the Hospital first", 5.0) Say() end )
            end 
        
        end,
        OnLook = function() 
            StartSequence( function() Say("It's your typical village bar", 5.0) Say() end )
        end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "TurnToPlazaReturn", Cursor = "MDown", Pos = { x = 0, y = 370 }, 
        Size = { Width = 920, Height = 140 }} end, OnInteract = function() SwipeScene("PlazaReturn", "Up") end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "PanToPlaza", Cursor = "MLeft", Pos = { x = 0, y = 70 },
        Size = { Width = 100, Height = 300 }} end, OnInteract = function() SwipeScene("PlazaPan", "Right") 
        if PlazaPan.State == 1 then PlazaPan.GoLeft() end end  } 
    },

    { Quad = { OnConstruct = function() return { NameId = "PanToHospital", Cursor = "MRight", Pos = { x = 750, y = 70 },
        Size = { Width = 165, Height = 300 }} end, OnInteract = function() SwipeScene("HospitalOutside", "Left") end }
    }
}
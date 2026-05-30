return {
    { Entity = "HospitalInBG", Textures = {
        {MedicDay = "data/Scenes/Town/Medic.jpg"}} 
    },

    { Quad = { OnConstruct = function() return { NameId = "ReturnToHospitalOut", Cursor = "MDown", Pos = { x = 0, y = 370 }, 
        Size = { Width = 920, Height = 140 }} end, OnInteract = function() SwipeScene("HospitalOutside", "Up") end } 
    }

}
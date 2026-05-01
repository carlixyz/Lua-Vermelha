return {
    { Entity = "Hospital", Textures = {
        {HospitalDay = "data/Scenes/Town/HospitalOutDay.jpg"}, 
        {HospitalNight = "data/Scenes/Town/HospitalOutNight.jpg"}, 
        {HospitalLua = "data/Scenes/Town/HospitalOutLua.jpg" }, 
        {Medic = "data/Scenes/Town/Medic.jpg" }} 
    },

    { Quad = { OnConstruct = function() return { NameId = "Bar side", Position = { x = 600, y = 100 },
        Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("Bar", "Down") end } 
    }
}
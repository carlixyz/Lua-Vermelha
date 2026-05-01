return {
    { Entity = "PlazaPan", Position = { x = 0, y = 0 }, Textures = {
        {PlazaPanDay = "data/Scenes/Town/PlazaPanDay.jpg"}, 
        {PlazaPanSunset = "data/Scenes/Town/PlazaPanSunset.jpg"}, 
        {PlazaPanNight = "data/Scenes/Town/PlazaPanNight.jpg"}, 
        {PlazaPanThug = "data/Scenes/Town/PlazaPanNightThugs.jpg"}, 
        {PlazaPanFire = "data/Scenes/Town/PlazaPanNightFire.jpg"}, 
        {PlazaPanLua = "data/Scenes/Town/PlazaPanLua.jpg" }} 
    },

    { Entity = "Thugs", Textures = {
        {ThugsFar = "data/Scenes/Town/ThugsFar.jpg"}, {ThugsNear = "data/Scenes/Town/ThugsFar.jpg"} }, Visible = false },

    { Quad = { OnConstruct = function() return { NameId = "Path ending", Position = { x = 600, y = 100 },
        Size = { Width = 200, Height = 280 }} end, OnInteract = function() SwipeScene("PlazaExit", "Down") end } 
    }
}
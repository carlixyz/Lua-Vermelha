return {
    { Entity = "TownPathDeepBG", Textures = {
        {TownPathDeep = "data/Scenes/Parking/TownPathDeep.jpg"}}
    },

    { Quad = { OnConstruct = function() return { NameId = "Woods Path Deep", Cursor = "MUp", Pos = { x = 440, y = 140 }, 
        Size = { Width = 160, Height = 180 }} end, OnInteract = function() SwipeScene("TownView", "Up") end } 
    },


    { Quad = { OnConstruct = function() return { NameId = "Road Path Return", Cursor = "MDown", Pos = { x = 377, y = 395 }, 
        Size = { Width = 370, Height = 115 }} end, OnInteract = function() SwipeScene("TownPath", "Up") end } 
    }
}
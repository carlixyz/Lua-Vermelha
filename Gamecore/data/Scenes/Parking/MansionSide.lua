
BirdsID = nil

function BirdsSinging()
    PlaySound("Birds")
end

function PlayBirds()
    if BirdsID then return end

    BirdsSinging()
    BirdsID = ScheduleRepeat(11, "BirdsSinging", "BirdsCancelID")
end

function StopBirds()
    if not BirdsID then return end

    CancelScheduled(BirdsID)
    BirdsID = nil
end

return {
    { Entity = "MansionSideBG", Textures = {
        {FachadeSide = "data/Scenes/Parking/FachadeSide.jpg"}, 
        {FachadeSideBike = "data/Scenes/Parking/FachadeBike.jpg"}}
    },

    { Entity = "MansionSideTop", Position = { x = 0, y = 0 }, Textures = "data/Scenes/Parking/ParkTop.jpg", Visible = false, Alpha = 0.0  },

    { Quad = { OnConstruct = function() return { NameId = "Road Path",  Cursor = "MUp", 
        Position = { x = 600, y = 100 }, Size = { Width = 200, Height = 280 }} end,
        OnInit = function() PlayBirds() FadeMusic(0.2) end, OnEnter = function() PlayMusic("WoodNote") PlayBirds() FadeMusic(0.2) end,
        OnInteract = function() 
            if not IsEntityInScene("Ada","MansionSide") then
                FadeMusic(0.0)
                SwipeScene("RoadPath", "Down") 
            end
        end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "Town Path & Car", Cursor = "MUp", Position = { x = 300, y = 100 },
        Size = { Width = 280, Height = 280 }} end, OnInteract = function() FadeMusic(0.0)  SwipeScene("TownPath", "Down") end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "Mansion\nFront", Cursor = "MLeft", Pos = { x = 0, y = 80 }, 
        Size = { Width = 200, Height = 516 }} end, 
        OnInteract = function() 
            StopBirds()            
            FadeMusic(0.2) 
            SwipeScene("MansionFront", "Right") 
        end } 
    }

}
return {

    { FireplaceScene = (function() 
        local self = { State = 0}
        function self.OnConstruct() 
            return { Clickable = false, Visible = true, Textures = {    
                {FireDay = "data/Scenes/Mansion/LobbyFireDay.jpg"}, 
                {FireSunset = "data/Scenes/Mansion/LobbyFireSunset.jpg"}, 
                {FireMoon = "data/Scenes/Mansion/LobbyFireMoon.jpg"}, 
                {FireNight = "data/Scenes/Mansion/LobbyFireNight.jpg"}, 
                {FireBrain = "data/Scenes/Mansion/LobbyFireBrain.jpg" }
            } } 
        end

        function self.OnInit()
            self.OnEnter()
        end

        function self.OnEnter()
        end

        return self
        end)()
    },


    { Quad = (function() 
        local self = {}
        function self.OnConstruct() return { Clickable = true, NameId = "FirestartExit", Cursor = "MDown",
            Pos = { x = 0, y = 350 }, Size = { Width = 920, Height = 160 }} end
        function self.OnInteract() SwipeScene("Lobby", "Up") end 
        return self
    end)()
    },


    { Quad = { OnConstruct = function() return { NameId = "OldPhoto", NameView = "Old Photo", Clickable = true, 
        Pos = { x = 490, y = 225 }, Size = { Width = 142, Height = 92 }} end, 
        OnInteract = function() BlendScene("FamilyPhoto", 1) end,
        OnLook = function() StartSequence(function() Say("Looks like a lovely family", 3.0) Say() end) end } 
    }, -- PICTURE

    { Quad = { OnConstruct = function() return { NameId = "URN", NameView = "URN", Clickable = true, 
        Pos = { x = 347, y = 141 }, Size = { Width = 107, Height = 176 }} end, 
        OnInteract = function() StartSequence(function() Say("I'm not going to touch that...", 3.0) Say() end) end,
        OnLook = function() StartSequence(function() Say("It looks like a plants vase,\nbut I think it's something else.", 6.0) Say() end) end } 
    }, -- URN

    { MatchesHotspot = { OnConstruct = function()  return { NameView = "Matches", Clickable = true, 
        Pos = { x = 230, y = 230 }, Textures = "data/Scenes/Mansion/LobbyMatches.png"} end, 
        OnInteract = function()
            StartSequence(function() Say("These might be useful later", 3.0) PickUp("Matches", 2)
            SetVisible("MatchesHotspot", false) SetClickable("MatchesHotspot", false) Say() end) end,
        OnLook = function()  StartSequence(function() Say("A set of matches to make fire", 3.0) Say() end) end } 
    }, -- MATCHES HOTSPOT

    { Matches = (function() local self = {}
        function self.OnConstruct() return {NameView = "Matches", Textures = "data/Scenes/Inventory/Matches.png", Visible = false } end
        function self.OnLookComment() Say("A set of matches to make fire\nTheme is about a Red moon or something", 4.0) Say() end
        function self.OnLook() StartSequence(self.OnLookComment) end
        return self
        end)() 
    } -- MATCHES

}
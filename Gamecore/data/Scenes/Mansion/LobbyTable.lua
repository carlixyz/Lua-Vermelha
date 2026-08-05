return {

    { Quad = (function() local self = { }
        function self.OnConstruct() return { Clickable = true, NameId = "NewsExit", Cursor = "MDown",
            --Pos = { x = 0, y = 410 }, Size = { Width = 920, Height = 100 }} end
            Pos = { x = 0, y = 460 }, Size = { Width = 920, Height = 50 }} end
        function self.OnInteract()
            BlendScene("Lobby", 1) 
        end 
        return self
    end)()
    },  -- SCENE EXIT

    { Entity = "SmallTable", Clickable = false, Textures =  {
        { STDay =  "data/Scenes/Mansion/LobbyTableDay.jpg"},
        { STSunset =  "data/Scenes/Mansion/LobbyTableSunset.jpg"},
        { STNight =  "data/Scenes/Mansion/LobbyTableNight.jpg"} }
    }, -- SMALL TABLE

    { MainKey = { OnConstruct = function() return { Pos = { x = 80, y = 250 }, NameView = "Main Key", 
        Textures = { {MainKeyDetail = "data/Scenes/Inventory/MainKeyDetail.png"}, 
            {MainKeyBase = "data/Scenes/Inventory/MainKey.png"} }, CurrentID = "MainKeyDetail" } end,
        OnInteract = function() PickUp("MainKey", 2) SetState("MainKey", "MainKeyBase") end,
        OnLook = function() 
            StartSequence( 
                function() 
                    if not IsEntityInScene("MainKey", "Inventory") then 
                        Say("This might be the main entrance key", 3.0) 
                    else
                        Say("A key from the Schwarz residence", 3.0) 
                    end
                end
            ) 
        end} 
    },  -- MAIN KEY


    { NewsPaper = { Unfolded = false , OnConstruct = function() return { NameView = "News Paper", Clickable = true,
        Textures = { { NewsFolded =  "data/Scenes/Mansion/NewsFolded.png"},
        { NewsUnfolded =  "data/Scenes/Mansion/NewsUnfolded.png"} }, CurrentID = "NewsFolded" } end,
        OnInteract = function()
            SetClickable("NewsPaper", false)
            SetState("NewsPaper", "NewsUnfolded") 

            Schedule(0.1, "SetClickable", "Headline")
            Schedule(0.1, "SetClickable", "Festival Advertise")
            Schedule(0.1, "SetClickable", "Low Row")
        end,
        OnLook = function() 
            StartSequence( 
                function() 
                    Say("It's an old sensasionalist news paper", 3.0) 
                    Say("I can't see anything important in this page..", 3.0) 
                    Say()
                end
            ) 
        end} 
    },  -- NEWSPAPER


    { Quad = (function() local self = {}
        function self.OnConstruct() return { NameId = "Headline", Clickable = false,
            Pos = { x = 262, y = 119 }, Size = { Width = 320, Height = 235 }} end
        function self.OnCommentLook() 
            Say("Mhh the headline talks about a missing man", 3.0) 
            Say("And it sounds like part of a series of homicides", 3.0) 
            Say() 
        end
        function self.OnInteract() StartSequence(self.OnCommentLook) end 
        function self.OnLook() StartSequence(self.OnCommentLook) end 
        return self
        end)()
    }, -- HEADLINE


    { Quad = (function() local self = {}
        function self.OnConstruct() return { NameId = "Festival Advertise", Clickable = false,
            Pos = { x = 591, y = 248 }, Size = { Width = 120, Height = 93 }} end
        function self.OnCommentLook() Say("It's an ad about the Lua Vermelha carnival or something", 3.0) Say() end
        function self.OnInteract() StartSequence(self.OnCommentLook) end 
        function self.OnLook() StartSequence(self.OnCommentLook) end 
        return self
        end)()
    }, -- LUA ADVERTISE

    { Quad = (function() local self = {}
        function self.OnConstruct() return { NameId = "Low Row", Clickable = false,
            Pos = { x = 246, y = 355 }, Size = { Width = 473, Height = 87 }} end
        function self.OnCommentLook() Say("Hidden Nazis, UFOs, A stolen Brain..\nit's just a bunch of written nonsense", 5.0) Say() end
        function self.OnInteract() StartSequence(self.OnCommentLook) end 
        function self.OnLook() StartSequence(self.OnCommentLook) end 
        return self
        end)()
    } -- LOW ROW


}
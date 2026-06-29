

return (function()

    local self = {
        EntityId = "Woods",
        AnimTask = 0,
        AnimFrameIds = {},
        CurrentFrame = 1,
        TimeBetweenFrames = 0.1,    
        TotalFrames = 92
    }

    function self.OnConstruct()
    return { 
        NameId = self.EntityId,
        Visible = false, 
        Clickable = false, 
        Textures = { 
            { WS00 = "data/Intro/Woods/woods_0000.jpg"}, 
            { WS01 = "data/Intro/Woods/woods_0001.jpg"}, 
            { WS02 = "data/Intro/Woods/woods_0002.jpg"}, 
            { WS03 = "data/Intro/Woods/woods_0003.jpg"}, 
            { WS04 = "data/Intro/Woods/woods_0004.jpg"}, 
            { WS05 = "data/Intro/Woods/woods_0005.jpg"}, 
            { WS06 = "data/Intro/Woods/woods_0006.jpg"}, 
            { WS07 = "data/Intro/Woods/woods_0007.jpg"}, 
            { WS08 = "data/Intro/Woods/woods_0008.jpg"}, 
            { WS09 = "data/Intro/Woods/woods_0009.jpg"}, 

            { WS10 = "data/Intro/Woods/woods_0010.jpg"}, 
            { WS11 = "data/Intro/Woods/woods_0011.jpg"}, 
            { WS12 = "data/Intro/Woods/woods_0012.jpg"}, 
            { WS13 = "data/Intro/Woods/woods_0013.jpg"}, 
            { WS14 = "data/Intro/Woods/woods_0014.jpg"}, 
            { WS15 = "data/Intro/Woods/woods_0015.jpg"}, 
            { WS16 = "data/Intro/Woods/woods_0016.jpg"}, 
            { WS17 = "data/Intro/Woods/woods_0017.jpg"}, 
            { WS18 = "data/Intro/Woods/woods_0018.jpg"}, 
            { WS19 = "data/Intro/Woods/woods_0019.jpg"}, 

            { WS20 = "data/Intro/Woods/woods_0020.jpg"}, 
            { WS21 = "data/Intro/Woods/woods_0021.jpg"}, 
            { WS22 = "data/Intro/Woods/woods_0022.jpg"}, 
            { WS23 = "data/Intro/Woods/woods_0023.jpg"}, 
            { WS24 = "data/Intro/Woods/woods_0024.jpg"}, 
            { WS25 = "data/Intro/Woods/woods_0025.jpg"}, 
            { WS26 = "data/Intro/Woods/woods_0026.jpg"}, 
            { WS27 = "data/Intro/Woods/woods_0027.jpg"}, 
            { WS28 = "data/Intro/Woods/woods_0028.jpg"}, 
            { WS29 = "data/Intro/Woods/woods_0029.jpg"}, 

            { WS30 = "data/Intro/Woods/woods_0030.jpg"},
            { WS31 = "data/Intro/Woods/woods_0031.jpg"},
            { WS32 = "data/Intro/Woods/woods_0032.jpg"},
            { WS33 = "data/Intro/Woods/woods_0033.jpg"},
            { WS34 = "data/Intro/Woods/woods_0034.jpg"},
            { WS35 = "data/Intro/Woods/woods_0035.jpg"},
            { WS36 = "data/Intro/Woods/woods_0036.jpg"},
            { WS37 = "data/Intro/Woods/woods_0037.jpg"},
            { WS38 = "data/Intro/Woods/woods_0038.jpg"},
            { WS39 = "data/Intro/Woods/woods_0039.jpg"},

            { WS40 = "data/Intro/Woods/woods_0040.jpg"},
            { WS41 = "data/Intro/Woods/woods_0041.jpg"},
            { WS42 = "data/Intro/Woods/woods_0042.jpg"},
            { WS43 = "data/Intro/Woods/woods_0043.jpg"},
            { WS44 = "data/Intro/Woods/woods_0044.jpg"},
            { WS45 = "data/Intro/Woods/woods_0045.jpg"},
            { WS46 = "data/Intro/Woods/woods_0046.jpg"},
            { WS47 = "data/Intro/Woods/woods_0047.jpg"},
            { WS48 = "data/Intro/Woods/woods_0048.jpg"},
            { WS49 = "data/Intro/Woods/woods_0049.jpg"},
            
            { WS50 = "data/Intro/Woods/woods_0050.jpg"},
            { WS51 = "data/Intro/Woods/woods_0051.jpg"},
            { WS52 = "data/Intro/Woods/woods_0052.jpg"},
            { WS53 = "data/Intro/Woods/woods_0053.jpg"},
            { WS54 = "data/Intro/Woods/woods_0054.jpg"},
            { WS55 = "data/Intro/Woods/woods_0055.jpg"},
            { WS56 = "data/Intro/Woods/woods_0056.jpg"},
            { WS57 = "data/Intro/Woods/woods_0057.jpg"},
            { WS58 = "data/Intro/Woods/woods_0058.jpg"},
            { WS59 = "data/Intro/Woods/woods_0059.jpg"},

            { WS60 = "data/Intro/Woods/woods_0060.jpg"},
            { WS61 = "data/Intro/Woods/woods_0061.jpg"},
            { WS62 = "data/Intro/Woods/woods_0062.jpg"},
            { WS63 = "data/Intro/Woods/woods_0063.jpg"},
            { WS64 = "data/Intro/Woods/woods_0064.jpg"},
            { WS65 = "data/Intro/Woods/woods_0065.jpg"},
            { WS66 = "data/Intro/Woods/woods_0066.jpg"},
            { WS67 = "data/Intro/Woods/woods_0067.jpg"},
            { WS68 = "data/Intro/Woods/woods_0068.jpg"},
            { WS69 = "data/Intro/Woods/woods_0069.jpg"},

            { WS70 = "data/Intro/Woods/woods_0070.jpg"},
            { WS71 = "data/Intro/Woods/woods_0071.jpg"},
            { WS72 = "data/Intro/Woods/woods_0072.jpg"},
            { WS73 = "data/Intro/Woods/woods_0073.jpg"},
            { WS74 = "data/Intro/Woods/woods_0074.jpg"},
            { WS75 = "data/Intro/Woods/woods_0075.jpg"},
            { WS76 = "data/Intro/Woods/woods_0076.jpg"},
            { WS77 = "data/Intro/Woods/woods_0077.jpg"},
            { WS78 = "data/Intro/Woods/woods_0078.jpg"},
            { WS79 = "data/Intro/Woods/woods_0079.jpg"},

            { WS80 = "data/Intro/Woods/woods_0080.jpg"},
            { WS81 = "data/Intro/Woods/woods_0081.jpg"},
            { WS82 = "data/Intro/Woods/woods_0082.jpg"},
            { WS83 = "data/Intro/Woods/woods_0083.jpg"},
            { WS84 = "data/Intro/Woods/woods_0084.jpg"},
            { WS85 = "data/Intro/Woods/woods_0085.jpg"},
            { WS86 = "data/Intro/Woods/woods_0086.jpg"},
            { WS87 = "data/Intro/Woods/woods_0087.jpg"},
            { WS88 = "data/Intro/Woods/woods_0088.jpg"},
            { WS89 = "data/Intro/Woods/woods_0089.jpg"},

            { WS90 = "data/Intro/Woods/woods_0090.jpg"},
            { WS91 = "data/Intro/Woods/woods_0091.jpg"}
        } 
    }
    end

    function self.OnInit()
        self.OnEnter()
    end

    function self.PlayAnimation()
        if self.AnimTask == 0 then
            self.AnimTask = ScheduleRepeat(self.TimeBetweenFrames, "OnDenseWoodAnimation", "CancelWoodAnim")
        end
    end

    function self.OnEnter()

        self.AnimFrameIds = GetEntityTextureIDs(self.EntityId)
        self.TotalFrames = #self.AnimFrameIds
        print(#self.AnimFrameIds)
        print(self.AnimFrameIds[self.CurrentFrame])
        --self.PlayAnimation()
    end

        
    function OnDenseWoodAnimation()
            
        SetState(self.EntityId, self.AnimFrameIds[self.CurrentFrame])

        self.CurrentFrame = self.CurrentFrame + 1
            
        if self.CurrentFrame > self.TotalFrames then
            self.CurrentFrame = 1
        end
    end

    function self.OnExit()
        self.OnStopAnimation()
    end

    function self.OnStopAnimation()
        if self.AnimTask ~= 0 then
            CancelScheduled(self.AnimTask)
            self.AnimTask = 0
        end
    end

    return self

end)()


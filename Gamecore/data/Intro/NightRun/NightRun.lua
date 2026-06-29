

return (function()

    local self = {
        EntityId = "NightRun",
        AnimTask = 0,
        AnimFrameIds = {},
        CurrentFrame = 1,
        TimeBetweenFrames = 0.05,    
        TotalFrames = 121
    }

    function self.OnConstruct()
    return { 
        NameId = self.EntityId,
        Visible = false, 
        Clickable = false, 
        Textures = { 
            { NR000 = "data/Intro/NightRun/night_000.jpg"}, 
            { NR001 = "data/Intro/NightRun/night_001.jpg"}, 
            { NR002 = "data/Intro/NightRun/night_002.jpg"}, 
            { NR003 = "data/Intro/NightRun/night_003.jpg"}, 
            { NR004 = "data/Intro/NightRun/night_004.jpg"}, 
            { NR005 = "data/Intro/NightRun/night_005.jpg"}, 
            { NR006 = "data/Intro/NightRun/night_006.jpg"}, 
            { NR007 = "data/Intro/NightRun/night_007.jpg"}, 
            { NR008 = "data/Intro/NightRun/night_008.jpg"}, 
            { NR009 = "data/Intro/NightRun/night_009.jpg"}, 

            { NR010 = "data/Intro/NightRun/night_010.jpg"}, 
            { NR011 = "data/Intro/NightRun/night_011.jpg"}, 
            { NR012 = "data/Intro/NightRun/night_012.jpg"}, 
            { NR013 = "data/Intro/NightRun/night_013.jpg"}, 
            { NR014 = "data/Intro/NightRun/night_014.jpg"}, 
            { NR015 = "data/Intro/NightRun/night_015.jpg"}, 
            { NR016 = "data/Intro/NightRun/night_016.jpg"}, 
            { NR017 = "data/Intro/NightRun/night_017.jpg"}, 
            { NR018 = "data/Intro/NightRun/night_018.jpg"}, 
            { NR019 = "data/Intro/NightRun/night_019.jpg"}, 

            { NR020 = "data/Intro/NightRun/night_020.jpg"}, 
            { NR021 = "data/Intro/NightRun/night_021.jpg"}, 
            { NR022 = "data/Intro/NightRun/night_022.jpg"}, 
            { NR023 = "data/Intro/NightRun/night_023.jpg"}, 
            { NR024 = "data/Intro/NightRun/night_024.jpg"}, 
            { NR025 = "data/Intro/NightRun/night_025.jpg"}, 
            { NR026 = "data/Intro/NightRun/night_026.jpg"}, 
            { NR027 = "data/Intro/NightRun/night_027.jpg"}, 
            { NR028 = "data/Intro/NightRun/night_028.jpg"}, 
            { NR029 = "data/Intro/NightRun/night_029.jpg"}, 

            { NR030 = "data/Intro/NightRun/night_030.jpg"},
            { NR031 = "data/Intro/NightRun/night_031.jpg"},
            { NR032 = "data/Intro/NightRun/night_032.jpg"},
            { NR033 = "data/Intro/NightRun/night_033.jpg"},
            { NR034 = "data/Intro/NightRun/night_034.jpg"},
            { NR035 = "data/Intro/NightRun/night_035.jpg"},
            { NR036 = "data/Intro/NightRun/night_036.jpg"},
            { NR037 = "data/Intro/NightRun/night_037.jpg"},
            { NR038 = "data/Intro/NightRun/night_038.jpg"},
            { NR039 = "data/Intro/NightRun/night_039.jpg"},

            { NR040 = "data/Intro/NightRun/night_040.jpg"},
            { NR041 = "data/Intro/NightRun/night_041.jpg"},
            { NR042 = "data/Intro/NightRun/night_042.jpg"},
            { NR043 = "data/Intro/NightRun/night_043.jpg"},
            { NR044 = "data/Intro/NightRun/night_044.jpg"},
            { NR045 = "data/Intro/NightRun/night_045.jpg"},
            { NR046 = "data/Intro/NightRun/night_046.jpg"},
            { NR047 = "data/Intro/NightRun/night_047.jpg"},
            { NR048 = "data/Intro/NightRun/night_048.jpg"},
            { NR049 = "data/Intro/NightRun/night_049.jpg"},
            
            { NR050 = "data/Intro/NightRun/night_050.jpg"},
            { NR051 = "data/Intro/NightRun/night_051.jpg"},
            { NR052 = "data/Intro/NightRun/night_052.jpg"},
            { NR053 = "data/Intro/NightRun/night_053.jpg"},
            { NR054 = "data/Intro/NightRun/night_054.jpg"},
            { NR055 = "data/Intro/NightRun/night_055.jpg"},
            { NR056 = "data/Intro/NightRun/night_056.jpg"},
            { NR057 = "data/Intro/NightRun/night_057.jpg"},
            { NR058 = "data/Intro/NightRun/night_058.jpg"},
            { NR059 = "data/Intro/NightRun/night_059.jpg"},

            { NR060 = "data/Intro/NightRun/night_060.jpg"},
            { NR061 = "data/Intro/NightRun/night_061.jpg"},
            { NR062 = "data/Intro/NightRun/night_062.jpg"},
            { NR063 = "data/Intro/NightRun/night_063.jpg"},
            { NR064 = "data/Intro/NightRun/night_064.jpg"},
            { NR065 = "data/Intro/NightRun/night_065.jpg"},
            { NR066 = "data/Intro/NightRun/night_066.jpg"},
            { NR067 = "data/Intro/NightRun/night_067.jpg"},
            { NR068 = "data/Intro/NightRun/night_068.jpg"},
            { NR069 = "data/Intro/NightRun/night_069.jpg"},

            { NR070 = "data/Intro/NightRun/night_070.jpg"},
            { NR071 = "data/Intro/NightRun/night_071.jpg"},
            { NR072 = "data/Intro/NightRun/night_072.jpg"},
            { NR073 = "data/Intro/NightRun/night_073.jpg"},
            { NR074 = "data/Intro/NightRun/night_074.jpg"},
            { NR075 = "data/Intro/NightRun/night_075.jpg"},
            { NR076 = "data/Intro/NightRun/night_076.jpg"},
            { NR077 = "data/Intro/NightRun/night_077.jpg"},
            { NR078 = "data/Intro/NightRun/night_078.jpg"},
            { NR079 = "data/Intro/NightRun/night_079.jpg"},

            { NR080 = "data/Intro/NightRun/night_080.jpg"},
            { NR081 = "data/Intro/NightRun/night_081.jpg"},
            { NR082 = "data/Intro/NightRun/night_082.jpg"},
            { NR083 = "data/Intro/NightRun/night_083.jpg"},
            { NR084 = "data/Intro/NightRun/night_084.jpg"},
            { NR085 = "data/Intro/NightRun/night_085.jpg"},
            { NR086 = "data/Intro/NightRun/night_086.jpg"},
            { NR087 = "data/Intro/NightRun/night_087.jpg"},
            { NR088 = "data/Intro/NightRun/night_088.jpg"},
            { NR089 = "data/Intro/NightRun/night_089.jpg"},

            { NR090 = "data/Intro/NightRun/night_090.jpg"},
            { NR091 = "data/Intro/NightRun/night_091.jpg"},
            { NR092 = "data/Intro/NightRun/night_092.jpg"},
            { NR093 = "data/Intro/NightRun/night_093.jpg"},
            { NR094 = "data/Intro/NightRun/night_094.jpg"},
            { NR095 = "data/Intro/NightRun/night_095.jpg"},
            { NR096 = "data/Intro/NightRun/night_096.jpg"},
            { NR097 = "data/Intro/NightRun/night_097.jpg"},
            { NR098 = "data/Intro/NightRun/night_098.jpg"},
            { NR099 = "data/Intro/NightRun/night_099.jpg"},

            { NR100 = "data/Intro/NightRun/night_100.jpg"},
            { NR101 = "data/Intro/NightRun/night_101.jpg"},
            { NR102 = "data/Intro/NightRun/night_102.jpg"},
            { NR103 = "data/Intro/NightRun/night_103.jpg"},
            { NR104 = "data/Intro/NightRun/night_104.jpg"},
            { NR105 = "data/Intro/NightRun/night_105.jpg"},
            { NR106 = "data/Intro/NightRun/night_106.jpg"},
            { NR107 = "data/Intro/NightRun/night_107.jpg"},
            { NR108 = "data/Intro/NightRun/night_108.jpg"},
            { NR109 = "data/Intro/NightRun/night_109.jpg"},

            { NR110 = "data/Intro/NightRun/night_110.jpg"},
            { NR111 = "data/Intro/NightRun/night_111.jpg"},
            { NR112 = "data/Intro/NightRun/night_112.jpg"},
            { NR113 = "data/Intro/NightRun/night_113.jpg"},
            { NR114 = "data/Intro/NightRun/night_114.jpg"},
            { NR115 = "data/Intro/NightRun/night_115.jpg"},
            { NR116 = "data/Intro/NightRun/night_116.jpg"},
            { NR117 = "data/Intro/NightRun/night_117.jpg"},
            { NR118 = "data/Intro/NightRun/night_118.jpg"},
            { NR119 = "data/Intro/NightRun/night_119.jpg"},
            { NR120 = "data/Intro/NightRun/night_120.jpg"}

        } 
    }
    end

    function self.OnInit()
        self.OnEnter()
    end

    function self.PlayAnimation()
        if self.AnimTask == 0 then
            self.AnimTask = ScheduleRepeat(self.TimeBetweenFrames, "OnNightRunAnimation", "CancelNightAnim")
        end
    end

    function self.OnEnter()

        self.AnimFrameIds = GetEntityTextureIDs(self.EntityId)
        self.TotalFrames = #self.AnimFrameIds
        print(#self.AnimFrameIds)
        print(self.AnimFrameIds[self.CurrentFrame])

        self.PlayAnimation()
    end

        
    function OnNightRunAnimation()
            
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




return (function()

    local self = {
        EntityId = "Flame",
        AnimTask = 0,
        AnimFrameIds = {},
        CurrentFrame = 1,
        TimeBetweenFrames = 0.075, --0.1 --0.05
        TotalFrames = 19
    }

    function self.OnConstruct()
    return { 
        NameId = self.EntityId,
        Visible = true, 
        Clickable = false,
        Alpha = 0.0,
        Textures = { 
            { FL01 = "data/Intro/Flame/flame_01.jpg"},
            { FL02 = "data/Intro/Flame/flame_02.jpg"},
            { FL03 = "data/Intro/Flame/flame_03.jpg"},
            { FL04 = "data/Intro/Flame/flame_04.jpg"},
            { FL05 = "data/Intro/Flame/flame_05.jpg"},
            { FL06 = "data/Intro/Flame/flame_06.jpg"},
            { FL07 = "data/Intro/Flame/flame_07.jpg"},
            { FL08 = "data/Intro/Flame/flame_08.jpg"},
            { FL09 = "data/Intro/Flame/flame_09.jpg"},
            { FL10 = "data/Intro/Flame/flame_10.jpg"},
            { FL11 = "data/Intro/Flame/flame_11.jpg"},
            { FL12 = "data/Intro/Flame/flame_12.jpg"},
            { FL13 = "data/Intro/Flame/flame_13.jpg"},
            { FL14 = "data/Intro/Flame/flame_14.jpg"},
            { FL15 = "data/Intro/Flame/flame_15.jpg"},
            { FL16 = "data/Intro/Flame/flame_16.jpg"},
            { FL17 = "data/Intro/Flame/flame_17.jpg"},
            { FL18 = "data/Intro/Flame/flame_18.jpg"},
            { FL19 = "data/Intro/Flame/flame_19.jpg"},
            { FL20 = "data/Intro/Flame/flame_20.jpg"}
            
        } 
    }
    end

    function self.OnInit()
        self.OnEnter()
    end

    function self.PlayAnimation()
        if self.AnimTask == 0 then
            self.AnimTask = ScheduleRepeat(self.TimeBetweenFrames, "OnTrashFlameAnimation", "CancelFlameAnim")
        end
    end

    function self.OnEnter()

        self.AnimFrameIds = GetEntityTextureIDs(self.EntityId)
        self.TotalFrames = #self.AnimFrameIds
        --print(#self.AnimFrameIds)
        --print(self.AnimFrameIds[self.CurrentFrame])
        --self.PlayAnimation()
    end

        
    function OnTrashFlameAnimation()
            
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


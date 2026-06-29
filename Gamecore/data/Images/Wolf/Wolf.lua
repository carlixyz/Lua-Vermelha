return {

  { Wolf = (function()
        local self = {
            AnimTask = 0,
            AnimFrameIds = {},
            CurrentFrame = 1,
            TimeBetweenFrames = 0.05,    
            RunForwardTotalFrames = 16,
            RunSideTotalFrames = 10,
            JumpscareTotalFrames = 2

        }
        function self.OnConstruct()
        return { 
            Clickable = false, 
            Textures = { 
                { WR00 = "data/Images/Wolf/WolfRun00.jpg"},
                { WR01 = "data/Images/Wolf/WolfRun01.jpg"},
                { WR02 = "data/Images/Wolf/WolfRun02.jpg"},
                { WR03 = "data/Images/Wolf/WolfRun03.jpg"},
                { WR04 = "data/Images/Wolf/WolfRun04.jpg"},
                { WR05 = "data/Images/Wolf/WolfRun05.jpg"},
                { WR06 = "data/Images/Wolf/WolfRun06.jpg"},
                { WR07 = "data/Images/Wolf/WolfRun07.jpg"},
                { WR08 = "data/Images/Wolf/WolfRun08.jpg"},
                { WR09 = "data/Images/Wolf/WolfRun09.jpg"},
                { WR10 = "data/Images/Wolf/WolfRun10.jpg"},
                { WR11 = "data/Images/Wolf/WolfRun11.jpg"},
                { WR12 = "data/Images/Wolf/WolfRun12.jpg"},
                { WR13 = "data/Images/Wolf/WolfRun13.jpg"},
                { WR14 = "data/Images/Wolf/WolfRun14.jpg"},
                { WR15 = "data/Images/Wolf/WolfRun15.jpg"},
                { WR16 = "data/Images/Wolf/WolfRun16.jpg"},

                { WFA = "data/Images/Wolf/WolfFrontA.jpg"},
                { WFB = "data/Images/Wolf/WolfFrontB.jpg"},

                { WS00 = "data/Images/Wolf/WolfSide00.jpg"},
                { WS00 = "data/Images/Wolf/WolfSide01.jpg"},
                { WS00 = "data/Images/Wolf/WolfSide02.jpg"},
                { WS00 = "data/Images/Wolf/WolfSide03.jpg"},
                { WS00 = "data/Images/Wolf/WolfSide04.jpg"},
                { WS00 = "data/Images/Wolf/WolfSide05.jpg"},
                { WS00 = "data/Images/Wolf/WolfSide06.jpg"},
                { WS00 = "data/Images/Wolf/WolfSide07.jpg"},
                { WS00 = "data/Images/Wolf/WolfSide08.jpg"},
                { WS00 = "data/Images/Wolf/WolfSide09.jpg"},
                { WS00 = "data/Images/Wolf/WolfSide10.jpg"},
                
                { WSA = "data/Images/Wolf/WolfSideA.jpg"},
                { WSB = "data/Images/Wolf/WolfSideB.jpg"},

                { WWA = "data/Images/Wolf/WolfWildA.jpg"},
                { WWB = "data/Images/Wolf/WolfWildB.jpg"}
            } 
        }
        end

        function self.OnInit()
            self.OnEnter()
        end

        function self.OnEnter()
            --[[ 

            self.AnimFrameIds = GetEntityTextureIDs("TreeWind")
            self.TotalFrames = #self.AnimFrameIds
            print(#self.AnimFrameIds)


            if self.AnimTask == 0 then
                self.AnimTask = ScheduleRepeat(self.TimeBetweenFrames, "OnTreeAnimation", "CancelTreeAnim")
            end
            ]]--
        end
        
        function OnWolfAnimation()
            
            SetState( "Wolf", self.AnimFrameIds[self.CurrentFrame])
            --print(self.AnimFrameIds[self.CurrentFrame])

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
    }, -- Wolf


   

}
return {

    { PlazaPan = (function() 
        local self = { FirstTime = true, State = 1} -- State: 0 left, 1 right
        function self.OnConstruct() return { Clickable = false, Pos = { x = -600, y = 0 }, 
            Textures = {    
                {PlazaPanDay = "data/Scenes/Town/PlazaPanDay.jpg"}, 
                {PlazaPanSunset = "data/Scenes/Town/PlazaPanSunset.jpg"}, 
                {PlazaPanNight = "data/Scenes/Town/PlazaPanNight.jpg"}, 
                {PlazaPanThug = "data/Scenes/Town/PlazaPanNightThugs.jpg"}, 
                {PlazaPanFire = "data/Scenes/Town/PlazaPanNightFire.jpg"}, 
                {PlazaPanLua = "data/Scenes/Town/PlazaPanLua.jpg" }}
        } end

        function self.OnInit()
            Schedule( 1.0, "SetInventory", true)
            SetThunder(false)
            SetNoise(false)
        end

        function self.Update()
            if self.State == 0 then
                Move("PlazaPan", 0)
                Move("TunnelShortcut", 160, -220)
                Move("LupertaStatue", 450, -220)
                    
            elseif self.State == 1 then
                Move("PlazaPan", -600)
                Move("TunnelShortcut", 160, 220)
                Move("LupertaStatue", 450, 220)

            end
        end

        function self.GoLeft()
            if (self.State > 0) then
                self.State = self.State -1
                self.Update()
            else
                if self.FirstTime then
                    self.FirstTime = false
                    SwipeScene("BarOutside", "Right")
                else
                    SwipeScene("PlazaReturn", "Right")
                end
            end
        end

        function self.GoRight() 
            if (self.State < 1) then
                self.State = self.State +1 
                self.Update()
            else
                SwipeScene("TownView", "Left")
            end
        end

        return self
        end)()
    },

    { Quad = (function() local self = {}

        function self.OnConstruct()
            return {
                NameId = "PlazaLSide", NameView = "Left\nSide", Cursor = "MLeft",
                Position = { x = 0, y = 80 }, Size = { Width = 60, Height = 436 }, Clickable = true
            }
        end

        function self.OnInteract() PlazaPan.GoLeft() PlaySound("SwipeOut") end

        return self end)()
    }, -- LEFT SIDE

    { Quad = (function() local self = {}

        function self.OnConstruct()
            return {
                NameId = "PlazaRSide", NameView = "Right\nSide", Cursor = "MRight",
                Position = { x = 840, y = 0 }, Size = { Width = 80, Height = 516 }, Clickable = true
            }
        end

        function self.OnInteract() PlazaPan.GoRight() PlaySound("SwipeIn") end

        return self end)()
    }, -- RIGHT SIDE



    { Entity = "Thugs", Visible = false, Textures = {
        {ThugsFar = "data/Scenes/Town/ThugsFar.jpg"}, {ThugsNear = "data/Scenes/Town/ThugsFar.jpg"} }
    },

    { Quad = { OnConstruct = function() return { NameId = "TunnelShortcut", Cursor = "MUp", Pos = { x = 160, y = 220 }, 
        Size = { Width = 240, Height = 100 }} end, OnInteract = function() SwipeScene("PlazaExit", "Down") end } 
    },

    { Quad = { OnConstruct = function() return { NameId = "LupertaStatue", Pos = { x = 450, y = 220 }, 
        Size = { Width = 110, Height = 120 }} end, OnInteract = function() SwipeScene("Luperta", "Down") end } 
    }
}
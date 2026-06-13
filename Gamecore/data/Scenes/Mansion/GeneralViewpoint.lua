

return (function()
    local self = {
        Transitioning = false
    }

    function self.OnConstruct()
        return {
            Visible = true,
            Clickable = false,
            Pos = { x = 920, y = 512 },
            Alpha = 0.0,
            Scale = 3,
            Textures = {
                { MansionView     = "data/Scenes/Mansion/GeneralViewpoint.jpg"    },
                { MansionViewSide = "data/Scenes/Mansion/GeneralViewpointSeg.jpg"    }
            }
        }
    end

    function self.OnInit()
        print("called Mansion.OnInit")
        --Scale("MansionView", 3, 0.1)
    end

    function self.OnDeinit()
        print("called Mansion.OnDeinit")
    end

    function self.AnimatePan()
        if self.Transitioning == false then
            self.Transitioning = true
            Move("MansionView", -920, 512, 6)
            Schedule( 8, "Scale", "MansionView", 1.0, 8)
            Schedule( 6, "Move", "MansionView", 0, -100)
        end
    end

    function Reset()

    end

    function self.OnScreenInput()
    end

    function self.OnInteract()
        print("called Mansion.OnInteract")
    end

    function self.OnLook()
        print("called Mansion.OnLook")
    end

    return self
end)()


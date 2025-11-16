-- door.lua

--MansionDoor = MansionDoor or {}
--MansionDoor.Locked = true

return {
    OnConstruct = function()
        return {
            NameId = "Door",
            NextScene = "Boot",
            Locked = MansionDoor.Locked,
            Visible = false,
            Position = { x = 0, y = 0 },
            Alpha = 1.0
        }
    end,

    OnInteract = function()
        if not MansionDoor.Lock then
            print("The door won’t open.")
        end
    end
}
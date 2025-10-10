
-- door.lua
return {
    OnInit = function()
        print("Empty door initialized.")
        return {
            NameId = "Door",
            NextScene = "Boot",
            Visible = false,
            Position = { x = 0, y = 0 },
            Alpha = 1.0
        }
    end
}
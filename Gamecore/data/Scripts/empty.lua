
-- empty_entity.lua
return {
    OnInit = function()
        print("Empty entity initialized.")
        return {
            NameId = "Unnamed",
            Visible = false,
            Position = { x = 0, y = 0 },
            Alpha = 1.0
        }
    end
}
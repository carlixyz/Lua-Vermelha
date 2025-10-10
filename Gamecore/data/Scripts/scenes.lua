Scenes = {
    Boot = true, 
    Global = {
        { John = "data/Scripts/john.lua" }
    }, 
    "Title",
    End = false,
    Test = { 
        { Elder = "data/Scripts/elder.lua" },
        { Door = "data/Scripts/door.lua" },
        { Fountain = "data/Scripts/fountain.lua" }
    }
}



-- Set here the first scene to Initialize
Scenes.StartScene = "Test"

-- Set here a top access scene to have shared access
Scenes.SharedScene = "Global"
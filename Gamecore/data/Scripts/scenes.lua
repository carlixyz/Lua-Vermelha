
Scenes = {
    Boot = true,
    Global = {
        -- { John = "data/Scripts/john.lua" }
    }, 
    "Title",
    End = false,
    Test = { 
        { Fountain = "data/Scripts/fountain.lua" },
        { Elder = "data/Scripts/elder.lua" },
        { Door = "data/Scripts/door.lua" }
    },
    Test2 ={
        { John = "data/Scripts/john.lua" }
    }
}



-- Set here the first scene to Initialize
Scenes.StartScene = "Boot"

-- Set here a top access scene to have shared access
Scenes.SharedScene = "Global"
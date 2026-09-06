function StatusMenu()
    Choice(
        { "" },

        { "Save", function()
            Say("Feature not ready")
            Say("Come back later")
            StatusMenu()
        end },

        { "Return", function()
            SwipeScene("Title", "Up")
            TitleText.DoOptionsMenu()
        end }
    )
end


function StartStatusMenu()
    StartSequence(StatusMenu)
end


return {

    { Entity = "MansionTopBG",
        Textures = "data/Scenes/Parking/ParkTop.jpg",
        Visible = true,
        Alpha = 0.25
    },


    { Constellation = {

        OnEnter = function()
            if GetFlag("StatusEnabled") then
                Schedule(0.01, "StartStatusMenu")
            end
        end,

        OnInit = function()

            if not IsThreadStarted("Intro") then
                --StartThread("Intro")
                ForceThreadCompleted("Intro")
            end

            -- Head
            AddStar("You",      0.10, 0.28)
            AddStar("Intro",    0.15, 0.07)
            AddStar("MadWorld", 0.42, 0.17)

            AddLink("You", "Intro")
            AddLink("Intro", "MadWorld")
            AddLink("MadWorld", "You")

            -- Body
            AddStar("WoodMorning", 0.32, 0.38)
            AddStar("Maneater",    0.43, 0.35)
            AddStar("CrimeWave",   0.60, 0.46)

            AddLink("You", "WoodMorning")
            AddLink("WoodMorning", "Maneater")
            AddLink("Maneater", "CrimeWave")

            -- Lower body / legs
            AddStar("GhostsAgain",    0.42, 0.55)
            AddStar("BrainJar",       0.50, 0.87)
            AddStar("BlindingLights", 0.72, 0.68)

            AddLink("WoodMorning", "GhostsAgain")
            AddLink("GhostsAgain", "BrainJar")
            AddLink("You", "BrainJar")
            AddLink("BrainJar", "BlindingLights")
            
            Constellation.OnEnter()
        end,

    }},

}
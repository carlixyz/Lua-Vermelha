
-- Global conditions
HasMetElder = false
HasAcceptedQuest = false
HasKey = false
HeardVillageTale = false

-- Main conversation entry point
function Talk()
    Say("You arrive at the village square.")
    Say("An old man approaches you with a cautious look.")

    if HeardVillageTale then
        SecretTalk()
    else
        Choice(
            { not HasMetElder, "Greet the old man",
                function()
                    Say("The old man smiles faintly.")
                    Say("Elder: 'Ah, a new face... Welcome to our village.'")
                    HasMetElder = true
                    ElderTalk()
                end },

            { "Ignore him and walk away",
                function()
                    Say("You decide not to engage and walk past.")
                    Say("The elder looks disappointed as you leave.")
                    Talk()
                end }
        )
    end
end

-- Elder’s branch
function ElderTalk()
    
    Say("Elder: 'I sense you are a traveler in search of purpose.'")

    Choice(
        { not HasAcceptedQuest, "Ask about work",
            function()
                Say("Elder: 'We are troubled by wolves in the forest.'")
                Say("Elder: 'Will you help us?'")

                Choice(
                    { "Yes, I will help.",
                        function()
                            Say("Elder: 'Thank you, brave one.'")
                            Say("He hands you a small charm for protection.")
                            HasAcceptedQuest = true
                            Talk()
                        end },

                    { "No, I have no time.",
                        function()
                            Say("Elder: 'I see... perhaps you will reconsider.'")
                            Say("He turns away, waiting for you to return.")
                            -- loop back to ElderTalk so player can try again
                            Talk()
                        end }
                )
            end },

        { "Ask about the village",
            function()
                Say("Elder: 'This village has stood for centuries.'")
                Say("Elder: 'But lately, we live in fear of the forest.'")
                Say("Elder: 'Take this key, might be of help later'")
                HasKey = true
                HeardVillageTale = true
                Talk()
            end },

        { "Say goodbye",
            function()
                Say("Elder: 'Farewell, stranger. May fortune guide you.'")
            end }
    )
end

-- Another branch if the player got the key later
function SecretTalk()
   Say("Guard: 'You carry the elder’s key?'")

    if HasKey then
        Say("Guard: 'Then you may enter the shrine.'")
        Say("returning back to original Talk()'")
        Talk()
    else
       Say("Guard: 'Without the key, you cannot pass.'")
    end
end

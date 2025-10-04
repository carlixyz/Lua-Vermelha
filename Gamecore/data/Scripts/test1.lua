Condition1 = false
Condition2 = false

function OurTalkTest()

    Say("Hello Stranger.")
    Choice(
        -- Branch using an ACTION TABLE (deferred calls)
        { Condition1 == false, "Who are you?", {
            { Say, "I’m just a humble villager." },
            { Say, "Take this present" },
            { GiveItem, "Sword" },
            { Set, "Condition1", true },
            OurTalkTest
        } },

        -- Branch using an inline function (also deferred)
        { "Any quests for me?", 
            function()
                Say("Yes! Please collect 10 herbs for me.")
                Say("Ok, I have work.")
                Say("See you later.")
                --Condition1 = true
                DoTalk_2()                       -- plain function ref is fine
            end },

        -- Mixed: single action table with one Say
        { "Goodbye.", {
            { Say, "Farewell." }
        } },
                -- Mixed: single action table with one Say
        { "Goodbye too.", {
            { Say, "Farewell." }
        } }
    )
end

function DoTalk_2()
    if Condition2 == false then
        Say("Still here?")
        Condition2 = true
        OurTalkTest()
    else
        Say("Go away")
        Say("")
    end
end


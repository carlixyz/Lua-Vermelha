return {

    {CreditRoll = {
        OnInit = function()
            PushCredit("#Fade('7Title', 0.0, 10)")
            PushCredit("PROJECT LUA VERMELHA")
            PushCredit(2)

            PushCredit("Created by", "Charlie")
            PushCredit("Programming", "Charlie")
            PushCredit("Art Direction", "Charlie")
            PushCredit()

            PushCredit("Special Thanks")
            PushCredit("Raylib", "raysan5")
            PushCredit("Lua", "PUC-Rio")
            PushCredit(4)

            PushCredit("AI Buddies")
            PushCredit("Image & Video generation", "SORA")
            PushCredit("General code support", "Chat-GPT")
            PushCredit(4)

            PushCredit("Soundtrack music")
            PushCredit("We, the remnants of a dream", "Takeaki Watanabe (Watson from MusMus)")
            PushCredit("Wood note", "Takeaki Watanabe ")
            PushCredit("MusMus-BGM-005", "Takeaki Watanabe")
            PushCredit(4)

            PushCredit("Sound effects")
            PushCredit("Dark Crime Piano Drama (30s)", "Universfield")
            PushCredit("banging-on-door", "Universfield")
            PushCredit("Rustling Bushes Dried Leaves", "floraphonic")

            PushCredit("#Fade('7Title', 0.2, 10)")
            PushCredit(4)
            PushCredit("Thank you for playing")

            PushCredit("#StartSequence(TitleText.DoOptionsMenu)")
            --RollCredits()
        end}
    }
}
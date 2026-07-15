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

            PushCredit("Sound effects")
            PushCredit("Dark Crime Piano Drama (30s)", "Universfield")
            PushCredit("banging-on-door.mp3", "Universfield")
            PushCredit("#Fade('7Title', 0.2, 10)")
            PushCredit(4)
            PushCredit("Thank you for playing")

            PushCredit("#StartSequence(TitleText.DoOptionsMenu)")
            --RollCredits()
        end}
    }
}
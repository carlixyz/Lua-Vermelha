NightIntro = NightIntro or {}
NightIntro.Initialized = false


local function OnConstruct()
    print("called NightIntro.OnConstruct")

    return { NameId = "NightIntro" }
end



local function OnEnter()
    print("called NightIntro.OnInit") print()

    SetThunder(true)
    SetNoise(true)
    --SetVisible("Dark")

    SetAlpha( "Dark", 0.0)
    TriggerThunder( 2)


    Schedule( 6, "SetVisible", "Panel", true)
    Schedule( 7, "Fade", "Panel", 0.5, 3)


    Schedule( 2.0, "TriggerThunder", 1)
    Schedule( 4.0, "TriggerThunder", 3)


    Schedule( 5, "SetVisible", "JumpScare")
    Schedule( 5.2, "SetVisible", "JumpScare", false)

    Schedule( 5.4, "SetVisible", "JumpScare")
    Schedule( 5.6, "SetVisible", "JumpScare", false)

    Schedule( 6.0, "TriggerThunder", 1)
    Schedule( 7, "Fade", "Black", 0.0, 5)

    --Schedule(12, "Fade", "Panel", 0.6, 5)
    Schedule(12, "StartSequence", "OnIntroInteraction")
    --StartSequence(NightIntro.OnIntroInteraction) --StartSequence("OnNightDriveTalk") 

end


function OnIntroInteraction()
    print("called NightIntro.OnIntroInteraction")

    SetAlpha("Panel", 0.0)
    SetVisible("Panel")

    Say("Whoa, I'm very tired, I'm starting to see things...", 4.0)
    Fade("Panel", 0.6, 5)
    Say("those thunderbolts are freaking scary!")
    TriggerThunder( 2)
    
    Say("Now, What the heck is happening here?", 4.0)
    Say("Someone left a door open...", 3.0)
    TriggerThunder( 1)

    Say("What should I do?")

    Schedule( 1.0, "SetActive", "Rear mirror")
    Schedule( 1.0, "SetActive", "Door entry")
    Schedule( 1.0, "SetActive", "Fachade")

end

local function OnExit()

    EndSequence()

    SetVisible("Panel", false)
    SetAlpha("Panel", 0.0)
    SetAlpha("Black", 1.0)
    
    SetThunder(false)
    SetNoise(false)

end

local function OnInit()
    print("called NightIntro.OnEnter") print()

    OnEnter()
end



NightIntro.Initialized = false
NightIntro.OnConstruct = OnConstruct
NightIntro.OnIntroInteraction = OnIntroInteraction
NightIntro.OnInit = OnInit
NightIntro.OnEnter = OnEnter
NightIntro.OnExit = OnExit


return NightIntro
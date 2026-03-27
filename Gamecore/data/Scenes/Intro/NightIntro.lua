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
    ---PlaySound("Rumble")

    Schedule( 6, "SetVisible", "Panel", true)
    Schedule( 7, "Fade", "Panel", 0.5, 3)


    Schedule( 2.0, "TriggerThunder", 1)
    Schedule( 4.0, "TriggerThunder", 3)
    ---Schedule( 5.0, "PlaySound", "Thunderbolt")

    Schedule( 5, "SetVisible", "JumpScare")
    Schedule( 5.2, "SetVisible", "JumpScare", false)

    Schedule( 5.4, "SetVisible", "JumpScare")
    Schedule( 5.6, "SetVisible", "JumpScare", false)

    Schedule( 6.0, "TriggerThunder", 1)
    Schedule( 7, "Fade", "Black", 0.0, 5)

    Schedule(12, "StartSequence", "OnIntroInteraction")
    --StartSequence(NightIntro.OnIntroInteraction) --StartSequence("OnNightDriveTalk") 

end


function OnIntroInteraction()
    print("called NightIntro.OnIntroInteraction")

    SetAlpha("Panel", 0.0)
    SetVisible("Panel")
    ---PlaySound("Storm")

    Say("Oof I'm so tired, can't see anthing at this point...", 4.0)
    Fade("Panel", 0.6, 5)
    Say("those thunderbolts are roaring!")

    TriggerThunder( 2)

    Say("Now, What's up here?", 3.0)
    Say("Mhh Someone left a door open...", 3.0)
    
    SetActive("Rear mirror")
    SetActive("Door entry")
    SetActive("Fachade")
    TriggerThunder( 1)

    Say("\n\n\n Left click: Interactions | Right click: Look")

end

local function OnExit()

    EndSequence()

    SetVisible("Panel", false)
    SetAlpha("Panel", 0.0)
    SetAlpha("Black", 1.0)
    
    --SetThunder(false)
    --SetNoise(false)

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
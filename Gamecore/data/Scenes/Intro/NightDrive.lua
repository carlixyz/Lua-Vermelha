Drive = Drive or {}
Drive.IndicatorID = 0
Drive.Initialized = false


local function OnConstruct()
    print("called NightDrive.OnConstruct")

    return { NameId = "NightDrive" }
end


local function OnEnter()
    print("called NightDrive.OnInit") print()
    SetVisible("Dark")
    SetThunder(true)
    SetNoise(true)

    --Title("Charlie Lopez presents", 4.0, 48.0)
    Schedule( 2, "ShowTitle", "Charlie presents", 4.0, 48.0)
    
    --Title("LUA VERMELHA", 5, 72.0, 0, 0, 255, 255, 255, 64)
    Schedule( 7, "ShowTitle", "A FRACTAL SENSATION", 8, 72.0, 0, 0, 255, 255, 255, 64)   

    Schedule( 9, "Fade", "Dark", 0.0, 5)       --ScheduleDirector(5.0, "FadeEntity", "Dark", "0.0", "5.0")
    Schedule( 11, "OnNightDriveReady")
end

function OnNightDriveReady()
    Fade("Panel", 0.6, 5)
    StartSequence(OnNightDriveTalk) --StartSequence("OnNightDriveTalk") --StartSequence(Drive.OnNightDriveTalk)
end

function AlternateIndicator()
    --Schedule( 1, "AlternateIndicator")
    SetAlpha("Indicator", 1.0)
    Schedule(0.5, "Fade", "Indicator", 0.0, 0.5)
end



local function OnScreenInput()
    --print("called NightDrive.OnScreenInput")

    --Drive.Clicks = Drive.Clicks + 1
   
    --if Drive.Initialized == true then
    --  return
    --end

    -- simplest: text + position
    --Toast("Door is locked", 80, 420)

    -- specify duration
    --Toast("Objective updated", 80, 420, 3.0)

    -- full control: duration, size, RGBA
    --Toast("Quest complete!", 80, 420, 3.0, 28, 255, 255, 100, 255)

    -- simplest (uses default position: centered)
    --Title("The Mansion")

    -- full control (duration, size, position, RGBA)
    -- Title("The Mansion", 3.5, 64.0, 0, 0, 255, 128, 128, 255)
end

function OnNightDriveTalk()

    SetAlpha("Flood", 0)
    SetAlpha("Sign", 0)

    Say("A long Road vanishing into the endless dark.", 5.0)
    Move("RearMirror", 700, -16, 15)
    Say("This is me - traveling alone and late", 4.0)
    Say("somewhere along Rua Vacaria 101,", 4.0)
    Say("on a rainy Thursday night.", 3.0)

    SetAlpha("Panel", 0.7)
    Say("I'm a medical vendor for NAZ Laboratories", 4.0)
    Say("My job is to travel and find new clients", 4.0)
    Say("Pay isn't bad - shame it doesn't come with a driver.", 4.0)

    Say("Damn I feel Exhausted - hours behind the wheel", 4.0)
    Say("Just need a town, a bed, somewhere to stop and rest.", 4.0)
    TriggerThunder( 3)
    Say("But this storm hits, furious and hungry,", 4.0)
    Say("as if the night had teeth.", 3.0)
    TriggerThunder( 2)

    Say("It's getting worse out there. looks like a wall of water.", 5.0)
    Fade("Flood", 1.0, 6) Move("Flood", 1200, 80, 60)
    Say("The shoulders are flooding. Stopping is impossible -", 4.0)
    Say("need to get out of here before it swallows the whole road.", 5.0)

    Drive.IndicatorID = ScheduleRepeat( 1, "AlternateIndicator", "IndicatorCancelID")
    Schedule( 1, "SetVisible", "Indicator")     --SetVisible("Indicator")
    SetAlpha("Panel", 0.8)
    SetState("RearMirror", "M2")

    Say("Now what... a wheel is failing!", 3.0)
    Say("Come on, everything that can go wrong... got screwed at the same time", 5.0)
    Say(" ", 5.0)

    Fade("Sign", 1.0, 8) Move("Sign", 1200, 80, 60)
    TriggerThunder( 3, 120, 200)
    Say("'Fazenda Schwarz'... what's that supposed to be?", 3.0)
    Say("Maybe it's a Ranch, maybe a Manor, maybe there's a shelter", 4.0)

    SetState("RearMirror", "M3")
    Say("So, I've nothing to lose by knocking up there...", 3.0)
    Say("Yeah, Let's check it, I'm done for tonight...", 3.0)
    TriggerThunder( 1)

    CancelScheduled(Drive.IndicatorID) --CancelScheduled("IndicatorCancelID") --
    Fade( "Dark", 1.0, 5)
    Schedule( 6, "SetCurrentScene", "Intro")     --SetVisible("Indicator")

    -----------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------
end

local function OnInit()
    Drive.Initialized = true
    OnEnter()
end

local function OnExit()
    --SetEntityScene("Panel", "Global")
    --SetEntityFront("Panel") --SetEntityBack("Panel")
    SetVisible("Panel", false)

    EndSequence()
    --SetThunder(false)
    --SetNoise(false)
end



Drive.OnConstruct = OnConstruct
Drive.OnNightDriveTalk = OnNightDriveTalk
Drive.OnScreenInput = OnScreenInput
Drive.OnInit = OnInit
Drive.OnEnter = OnInit
Drive.OnExit = OnExit

return Drive
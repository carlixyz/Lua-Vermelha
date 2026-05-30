Ilsa = Ilsa or {}
Ilsa.TalkAnimID = 0
Ilsa.TalkFrame = 0
Ilsa.TalkCount = 0

Ilsa.TalkTimeMin = 4
Ilsa.TalkTimeMax = 9
Ilsa.TalkAmount = Ilsa.TalkTimeMin

Ilsa.QuietTimeMin = 10
Ilsa.QuietTimeMax = 20
Ilsa.QuietAmount = Ilsa.QuietTimeMin

local function OnConstruct()
    return {
        Visible = false,
        Clickable = false,
        Position = { x = 64, y = 0 },
        Textures = {
            { IRSerious =   "data/Actors/Ilsa/IRSerious.png"    },
            { IRSays =      "data/Actors/Ilsa/IRSays.png"       },
            { IRSmile =     "data/Actors/Ilsa/IRSmile.png"      },
            { IRSmiley =    "data/Actors/Ilsa/IRSmiley.png"     },
            { IRSurprise =  "data/Actors/Ilsa/IRSurprise.png"   },
            { IRKiss =      "data/Actors/Ilsa/IRKiss.png"       },

            { ITShut =      "data/Actors/Ilsa/ITShut.png"       },
            { ITSay =       "data/Actors/Ilsa/ITSay.png"        },
            { ITSmile =     "data/Actors/Ilsa/ITSmile.png"      },
            { ITSurprise =  "data/Actors/Ilsa/ITSurprise.png"   },
            { ITKiss =      "data/Actors/Ilsa/ITKiss.png"       },
            { ITStand =     "data/Actors/Ilsa/ITStand.png"      },

            { ISShut =      "data/Actors/Ilsa/ISShut.png"       },
            { ISSays =      "data/Actors/Ilsa/ISSays.png"       },
            { ISSmile =      "data/Actors/Ilsa/ISSmile.png"     },
            { ISSnatch =    "data/Actors/Ilsa/ISSnatch.png"     },
            { ISSavage =    "data/Actors/Ilsa/ISSavage.png"     },
            { ISWink =      "data/Actors/Ilsa/ISWink.png"       },
            { ISStandFront ="data/Actors/Ilsa/ISStandFront.png" },
            { ISStayBack =  "data/Actors/Ilsa/ISStayBack.png"   }
        }, CurrentImage = "IRSerious"
    }
end


local function OnInit()
    print("called Ilsa.OnInit")
end

local function OnDeinit()
    print("called Ilsa.OnDeinit")
end

local function StartTalk()
    if Ilsa.TalkAnimID == 0 then
        Ilsa.TalkAnimID = ScheduleRepeat( 0.15, "AnimateIlsaTalk", "CancelIlsaTalk")
    end
end

local function StopTalk()
    CancelScheduled(Ilsa.TalkAnimID)
    Ilsa.TalkAnimID = 0
    SetState("Ilsa", "IRSerious")
end

function AnimateIlsaTalk()
    if Ilsa.TalkCount <= Ilsa.TalkAmount and Ilsa.TalkFrame == 0 then
        SetState("Ilsa", "IRSays")
        Ilsa.TalkFrame = 1
    else
        SetState("Ilsa", "IRSerious")
        Ilsa.TalkFrame = 0
    end
        
    Ilsa.TalkCount = Ilsa.TalkCount + 1
    if Ilsa.TalkCount > Ilsa.QuietAmount then
        Ilsa.TalkCount  = 0
        Ilsa.TalkAmount = math.random(Ilsa.TalkTimeMin, Ilsa.TalkTimeMax)
        Ilsa.QuietAmount = math.random(Ilsa.QuietTimeMin, Ilsa.QuietTimeMax)
    end
end

local function OnInteract()
    print("called Ilsa.OnInteract")
    StartTalk()
end

local function OnLook()
    print("called Ilsa.OnLook")
    StopTalk()
end

Ilsa.StartTalk = StartTalk
Ilsa.StopTalk = StopTalk
Ilsa.AnimateIlsaTalk = AnimateIlsaTalk

return {
    StartTalk = StartTalk,
    StopTalk = StopTalk,
    AnimateIlsaTalk = AnimateIlsaTalk,

    OnConstruct = OnConstruct,
    OnInit = OnInit,
    OnDeinit = OnDeinit,
    OnLook = OnLook,
    OnInteract = OnInteract
}
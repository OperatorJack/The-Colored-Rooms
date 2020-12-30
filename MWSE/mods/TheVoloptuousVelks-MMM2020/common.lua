local common = {}

local debugMode = true
local prepend = '[VV 2020: DEBUG] '

function common.debug(str, ...)
    if (debugMode == true) then
        str = prepend .. str
        mwse.log(str, ...)
        tes3.messageBox(str, ...)
    end
end

common.markers = {
    vosCiel = "VV20_ActCielVosMarker",
    vosLirielle = "VV20_ActLirelleVosMarker"
}

common.globals = {
    hasContagion = "VV20_GlobalHasContagion"
}

common.npcs = {
    falx = "VV20_NpcFalx",
    meridia = "VV20_NpcMeridia",
    peryite = "VV20_NpcPeryite",
}

common.items = {
    dawnbreaker = "VV20_Dawnbreaker",
    cursedDawnbreaker = "VV20_CursedDawnbreaker"
}

common.spells = {
    absorbDisease = "VV20_SpellAbsorbDisease",
    contagion = "VV20_SpellContagion"
}
common.journals = {
    mq01 = "VV20_MQ_MysteriousRuin",
    mq02 = "VV20_MQ_ReturningTheContagion",
    fq01 = "VV20_FG_MissingGuildmates"
}

common.diseases = {
    {
        id = "VV20_DiseaseTrapTest1"
    },
    {
        id = "VV20_DiseaseTrapTest2"
    }
}

common.traps = {
    -- On a timer, checks proximity to player and triggers trap.
    timer = {
        ["VV20_TrapTimerStaticTest"] = {
            animate = true,
            proximity = 256
        }
    },
    -- Constantly checks proximity to player and triggers trap.
    proximity = {
        ["VV20_TrapProxStaticTest"] = {
            animate = true,
            proximity = 256,
            diseaseId = "VV20_DiseaseTrapTest3"
        }
    },
    -- Triggers trap on collision with player.
    collision = {
        ["VV20_TrapCollStaticTest"] = {
            animate = true
        }
    }
}

common.skybox = {
    cells = {
        ["CustomSkyTest"] = true
    }
}

return common
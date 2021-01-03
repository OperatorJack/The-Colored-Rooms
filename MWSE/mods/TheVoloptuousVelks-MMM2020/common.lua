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

function common.getKeyFromValueFunc(tbl, func)
    for key, value in pairs(tbl) do
        if (func(value) == true) then return key end
    end
    return nil
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
    ciel = "VV20_NpcCiel",
    lirielle = "VV20_NpcLirielle",
    barnand = "VV20_NpcBarnand",
    fevris = "VV20_NpcCultistFevris",

    ayleid_dyrurdant = "VV20_NpcAyleidDyrurdant",

    torture_folvys = "VV20_NpcTortureFolvys",

    prisoner_waylas = "VV20_NpcPrisonWaylas",
}

common.creatures = {
    auroranScript1 = "VV20_CreaAuroranScript1",
    auroranScript2 = "VV20_CreaAuroranScript2",
    auroranScript3 = "VV20_CreaAuroranScript3",
    cultistScript1 = "VV20_CreaCorCultScript1",
    cultistScript2 = "VV20_CreaCorCultScript2",
    cultistScript3 = "VV20_CreaCorCultScript3"
}

common.items = {
    dawnbreaker = "VV20_Dawnbreaker",
    cursedDawnbreaker = "VV20_CursedDawnbreaker"
}

common.spells = {
    absorbDisease = "VV20_SpellAbsorbDisease",
    cureDisease = "VV20_SpellCureDisease",
    contagion = "VV20_SpellContagion",
    summonAuroran = "VV20_SpellSummonAuroran",
    ability_Paralysis = "VV20_AbilParalysis",
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
        ["CustomSkyTest"] = true,
        ["The Colored Rooms"] = true,
    }
}

return common
local common = {}

local debugMode = true

common.debug = function (message)
    if (debugMode == true) then
        local prepend = '[VV 2020: DEBUG] '
        mwse.log(prepend .. message)
        tes3.messageBox(prepend .. message)
    end
end

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

return common
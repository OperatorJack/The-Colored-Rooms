local common = require("TheVoloptuousVelks-MMM2020.common")

local function isTrapTriggered(trap)
    return trap.data.VV20 and trap.data.VV20.triggered
end
local function setTrapTriggered(trap, table)
    trap.data.VV20 = trap.data.VV20 or {}
    trap.data.VV20.triggered = true
    table[trap] = nil
end

-- Trap Controller for non-event based traps.
local activeTimerTraps = {}
local timerTrapCallback

local activeProximityTraps = {}
local proximityTrapCallback

local function onReferenceActivated(e)
    if common.timer.collision[e.reference.object.id] then
        activeTimerTraps[e.reference] = tes3.getSimulationTimestamp() + math.random(5)
    end

    if common.proximity.collision[e.reference.object.id] then
        activeProximityTraps[e.reference] = true
    end
end
event.register("referenceActivated", onReferenceActivated)

local function onReferenceDeactivated(e)
    activeTimerTraps[e.reference] = nil
    activeProximityTraps[e.reference] = nil
end
event.register("referenceDeactivated", onReferenceDeactivated)

local function trapTimerCallback()
    for trapReference in pairs(activeTimerTraps) do
        timerTrapCallback(trapReference)
    end
    for trapReference in pairs(activeProximityTraps) do
        proximityTrapCallback(trapReference)
    end
end
timer.start{iterations = -1, duration = 0.15, callback=trapTimerCallback}


-- Timer Traps
-- TODO: Add delta time check to change how often they trigger.
timerTrapCallback = function(trap)
    local nextProcessTime = activeTimerTraps[trap]

    local config = common.traps.timer[trap.object.id]
    if (config and
        config.proximity and
        isTrapTriggered(trap) == false and
        tes3.player.position:distance(trap.position) <= config.proximity and
        nextProcessTime <= tes3.getSimulationTimestamp()
    ) then
        -- Trigger disease
        event.trigger("TheColoredRooms:TriggerDisease", {
            reference = tes3.player,
            diseaseId = config.diseaseId
        })

        if (config.animate) then
            -- Animate the trap somehow.
        end

        activeTimerTraps[trap] = tes3.getSimulationTimestamp() + math.random(7,12)
    end
end

-- Proximity Traps
proximityTrapCallback = function(trap)
    local config = common.traps.proximity[trap.object.id]
    if (config and
        config.proximity and
        isTrapTriggered(trap) == false and
        tes3.player.position:distance(trap.position) <= config.proximity
    ) then
        -- Trigger disease
        event.trigger("TheColoredRooms:TriggerDisease", {
            reference = tes3.player,
            diseaseId = config.diseaseId
        })

        setTrapTriggered(trap, activeProximityTraps)

        if (config.animate) then
            -- Animate the trap somehow.
        end
    end
end


-- Collision Traps
local function onCollision(e)
    local trap = e.target
    if (e.mobile == tes3.mobilePlayer and
        common.traps.collision[trap.object.id] and
        isTrapTriggered(trap) == false
    ) then
        local config = common.traps.collision[trap.object.id]

        -- Trigger disease
        event.trigger("TheColoredRooms:TriggerDisease", {
            reference = tes3.player,
            diseaseId = config.diseaseId
        })

        setTrapTriggered(trap)

        if (config.animate) then
            -- Animate the trap somehow.
        end
    end
end
event.register("collision", onCollision)
local common = require("TheVoloptuousVelks-MMM2020.common")

local function isTrapTriggered(trap)
    return trap.data.VV20 ~= nil and trap.data.VV20.triggered == true
end
local function setTrapTriggered(trap)
    trap.data.VV20 = trap.data.VV20 or {}
    trap.data.VV20.triggered = true
end

-- Trap Controller for non-event based traps.
local activeTimerTraps = {}
local timerTrapCallback

local activeProximityTraps = {}
local proximityTrapCallback

local function onReferenceActivated(e)
    if common.traps.timer[e.reference.object.id] then
        activeTimerTraps[e.reference] = tes3.getSimulationTimestamp() + math.random(5)
        common.debug("Activated Timer trap: %s", e.reference)
    end

    if common.traps.proximity[e.reference.object.id] then
        activeProximityTraps[e.reference] = true
        common.debug("Activated Proximity trap: %s", e.reference)
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

event.register("loaded", function()
    timer.start{iterations = -1, duration = 0.15, callback=trapTimerCallback}
end)


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
        common.debug("Processing Timer trap: %s", trap)

        -- Trigger disease
        event.trigger("TheColoredRooms:TriggerDisease", {
            reference = tes3.player,
            diseaseId = config.diseaseId
        })

        if (config.animate) then
            -- Animate the trap somehow.
            tes3.messageBox("Animation!")
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
        common.debug("Processing Proximity trap: %s", trap)

        -- Trigger disease
        event.trigger("TheColoredRooms:TriggerDisease", {
            reference = tes3.player,
            diseaseId = config.diseaseId
        })

        setTrapTriggered(trap)
        activeProximityTraps[trap] = nil

        if (config.animate) then
            -- Animate the trap somehow.
            tes3.messageBox("Animation!")
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
        common.debug("Processing Proximity trap: %s", trap)

        local config = common.traps.collision[trap.object.id]

        -- Trigger disease
        event.trigger("TheColoredRooms:TriggerDisease", {
            reference = tes3.player,
            diseaseId = config.diseaseId
        })

        setTrapTriggered(trap)

        if (config.animate) then
            -- Animate the trap somehow.
            tes3.messageBox("Animation!")
        end
    end
end
event.register("collision", onCollision)
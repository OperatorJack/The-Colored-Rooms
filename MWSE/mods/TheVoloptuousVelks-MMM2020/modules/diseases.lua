local common = require("TheVoloptuousVelks-MMM2020.common")

local function getRandomDisease()
    return tes3.getObject(common.diseases[math.random(#common.diseases)].id)
end

event.register("TheColoredRooms:TriggerDisease", function(e)
    mwscript.addSpell({
        reference = e.reference, 
        spell = getRandomDisease()
    })
end)
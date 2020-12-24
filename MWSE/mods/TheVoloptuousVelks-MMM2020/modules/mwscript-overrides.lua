local common = require("TheVoloptuousVelks-MMM2020.common")

local function distanceCheckForUpdate(reference, distance, journal, index)
    if (reference.position:distance(tes3.player.position) <= distance) then
        if (tes3.getJournalIndex({ id = journal}) < index ) then
            tes3.updateJournal({id=journal, index=index})
        end
    end
end

local function initialized()
    mwse.overrideScript("VV20_ScriptQuestCaveEntr", function(e)
        distanceCheckForUpdate(e.reference, 512, common.journals.mq01, 20)
    end)


    mwse.overrideScript("VV20_ScriptQuestPortal", function(e)
        distanceCheckForUpdate(e.reference, 512, common.journals.mq01, 40)
    end)
end

event.register("initialized", initialized)
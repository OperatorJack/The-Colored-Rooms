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

        if (tes3.getJournalIndex({ id = common.journals.fq01}) == 60 ) then
            local vosCielMarkerRef = tes3.getReference(common.markers.vosCiel)
            local vosLirielleMarkerRef = tes3.getReference(common.markers.vosLirielle)
            local cielRef = tes3.getReference(common.npcs.ciel)
            local lirielleRef = tes3.getReference(common.npcs.lirielle)

            if (cielRef.cell.id == vosCielMarkerRef.cell.id) then
                return
            end

            tes3.positionCell({
                reference = cielRef,
                position = vosCielMarkerRef.position,
                orientation = vosCielMarkerRef.orientation,
                cell = vosCielMarkerRef.cell
            })
            tes3.positionCell({
                reference = lirielleRef,
                position = vosLirielleMarkerRef.position,
                orientation = vosLirielleMarkerRef.orientation,
                cell = vosLirielleMarkerRef.cell
            })
        end
    end)


    mwse.overrideScript("VV20_ScriptQuestPortal", function(e)
        distanceCheckForUpdate(e.reference, 512, common.journals.mq01, 40)
    end)
end

event.register("initialized", initialized)
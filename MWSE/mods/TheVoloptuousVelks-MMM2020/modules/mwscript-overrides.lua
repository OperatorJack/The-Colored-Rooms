local common = require("TheVoloptuousVelks-MMM2020.common")

local function engage(combatants, targets)
    for _, combatant in ipairs(combatants) do
        for _, target in ipairs(targets) do
            if (combatant and target) then
                combatant.mobile:startCombat(target.mobile)
                target.mobile:startCombat(combatant.mobile)
            end
        end 
    end
end

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

    mwse.overrideScript("VV20_ScriptQuestVarosTradehouse", function(e)
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

    mwse.overrideScript("VV20_ScriptQuestCaveFight", function(e)
        if (e.reference.position:distance(tes3.player.position) <= 1024) then
            local auroran1 = tes3.getReference(common.creatures.auroranScript1)
            local auroran2 = tes3.getReference(common.creatures.auroranScript2)
            local auroran3 = tes3.getReference(common.creatures.auroranScript3)
            
            local cultist1 = tes3.getReference(common.creatures.cultistScript1)
            local cultist2 = tes3.getReference(common.creatures.cultistScript2)
            local cultist3 = tes3.getReference(common.creatures.cultistScript3)

            aurorans = {auroran1, auroran2, auroran3}
            cultists = {cultist1, cultist2, cultist3}
            
            engage(aurorans, cultists)

            e.reference:disable()
        end
    end)

    mwse.overrideScript("VV20_ScriptEventDyrurdant", function(e)
        if (e.reference.position:distance(tes3.player.position) <= 512) then
            local ayleid = tes3.getReference(common.npcs.ayleid_dyrurdant)
            local victim = tes3.getReference(common.npcs.torture_folvys)

            if (victim.mobile.isDead ~= true) then
                victim.mobile:applyHealthDamage(1000)
                ayleid.mobile:startCombat(tes3.mobilePlayer)
                e.reference:disable()
            end
        end
    end)
end

event.register("initialized", initialized)
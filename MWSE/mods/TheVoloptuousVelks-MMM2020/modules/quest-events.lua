local common = require("TheVoloptuousVelks-MMM2020.common")

-- 
-- Handle player curing themselves of the contagion.
--
event.register("spellTick", function(e)
    if (e.effectId == tes3.effect.cureCommonDisease and
        e.effectInstance.target == tes3.player and
        tes3.getJournalIndex({ id = common.journals.mq02}) == 1000) then
        tes3.updateJournal({id=common.journals.mq02, index=4000})
        tes3.setGlobal(common.globals.hasContagion, 0)
    end
end)
-----------------------------------------------------

-- 
-- Handle Absorb Disease being cast on Falx
--
event.register("spellTick", function(e)
    if (e.target.baseObject.id == common.npcs.falx and
        e.source.id == common.spells.absorbDisease) 
    then
        e.target.mobile:applyHealthDamage(1000)
        tes3.updateJournal({id=common.journals.mq01, index=90})
        tes3.setGlobal(common.globals.hasContagion, 1)
    end
end)

event.register("cellChanged", function(e)
    timer.start({
        duration = 2,
        callback = function()
            if (tes3.getJournalIndex({ id = common.journals.mq01}) == 90 and
                tes3.getJournalIndex({ id = common.journals.mq02}) < 1000) then
                tes3.updateJournal({id=common.journals.mq02, index=1000})
            end
        end
    })
end)

-----------------------------------------------------

--
-- Handle talking to Meridia & Peryite activators.
--
local links = {
    ["VV20_ActMeridia"] = {
        id = common.npcs.meridia,
        stages = {
            {
                journal = common.journals.mq01,
                min = 0,
                max = 80
            }
        }
    },
    ["VV20_ActPeryite"] = {
        id = common.npcs.peryite,
        stages = {
            {
                journal = common.journals.mq01,
                min = 70,
                max = 80
            },
            {
                journal = common.journals.mq02,
                min = 1000,
                max = 3000
            }
        }
    },
}
event.register("activate", function(e)
    local link = links[e.target.baseObject.id]
    if (link) then
        for _, stage in ipairs(link.stages) do
            local index = tes3.getJournalIndex({ id = stage.journal})
            if (index >= stage.min and index <= stage.max) then
                local contagion = tes3.getObject(common.spells.contagion)
                if (tes3.player.object.spells:contains(contagion)) then
                    tes3.setGlobal(common.globals.hasContagion, 1)
                else      
                    tes3.setGlobal(common.globals.hasContagion, 0)
                end

                local ref = tes3.getReference(link.id)
                if (not ref) then
                    tes3.messageBox("MWSE Error. Save, restart MW and try again.")
                    return false
                end

                tes3.player:activate(ref)
                return false
            end
        end
    end
end)
-----------------------------------------------------

-- 
-- Handle Falx attack with Dawnbreaker
--
event.register("attack", function (e)
    if (e.mobile == tes3.mobilePlayer and
        e.targetReference.baseObject.id == common.npcs.falx and
        e.mobile.readiedWeapon.object.id == common.items.dawnbreaker and
        tes3.getJournalIndex({ id = common.journals.mq01}) == 50) then
            timer.start({
                duration = .5,
                callback = function()
                    tes3.removeItem({ reference = tes3.player, item = common.items.dawnbreaker})
                    tes3.addItem({ reference = tes3.player, item = common.items.cursedDawnbreaker})
                    mwscript.equip({ reference = tes3.player, item = common.items.cursedDawnbreaker})
                    tes3.updateJournal({id=common.journals.mq01, index=60})
                    e.reference:activate(e.targetReference)
                end
            })
            return false
    end
end)
-----------------------------------------------------

--
-- Handle activating Bernard
--
event.register("activate", function(e)
    if (e.target.baseObject.id == common.npcs.barnand and 
        tes3.getJournalIndex({ id = common.journals.fq01}) == 50) then
        tes3.updateJournal({id=common.journals.fq01, index=60})
    end
end)
-----------------------------------------------------

-- 
-- Handle Immortal NPCs who only die via scripting.
--
local immortals = {
    [common.npcs.falx] = true,
    [common.npcs.torture_folvys] = true,
    [common.npcs.prisoner_waylas] = true,
}

event.register("calcHitChance", function (e)
    if (immortals[e.targetMobile.reference.baseObject.id]) then
        e.hitChance = 0
    end
end)

event.register("combatStart", function (e)
    if (immortals[e.actor.reference.baseObject.id]) then
        return false
    end
end)

event.register("damage", function (e)
    if (immortals[e.reference.baseObject.id]) then
        e.damage = 0
        return false
    end
end)

event.register("spellResist", function (e)
    if (immortals[e.target.baseObject.id]) then
        local key = common.getKeyFromValueFunc(common.spells, function(value) if value == e.source.id then return true end end)
        if (not key) then
            e.resistedPercent = 100
            return false
        end
    end
end)
-----------------------------------------------------

-- 
-- Handle NPCs which cannot be activated.
--
local staticNpcs = {
    [common.npcs.torture_folvys] = true,
}

event.register("activate", function (e)
    if (staticNpcs[e.target.baseObject.id]) then
        return false
    end
end)
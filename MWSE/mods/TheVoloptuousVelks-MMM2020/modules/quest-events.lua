local common = require("TheVoloptuousVelks-MMM2020.common")

event.register("attack", function (e)
    if (e.mobile == tes3.mobilePlayer and
        e.targetReference.object.id == common.npcs.falx and
        e.mobile.readiedWeapon.id == common.items.dawnbreaker and
        tes3.getJournalIndex({ id = common.journals.mq01}) == 50) then
            tes3.removeItem({ reference = tes3.player, item = common.items.dawnbreaker})
            tes3.addItem({ reference = tes3.player, item = common.items.cursedDawnbreaker})
            mwscript.equip({ reference = tes3.player, item = common.items.cursedDawnbreaker})
            tes3.updateJournal({id=common.journals.mq01, index=60})
            e.mobile:active(e.targetReference)
            return false
    end
end)
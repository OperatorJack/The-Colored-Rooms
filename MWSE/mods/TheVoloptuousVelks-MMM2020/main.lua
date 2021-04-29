-- Check MWSE Build --
if (mwse.buildDate == nil) or (mwse.buildDate < 20201010) then
    local function warning()
        tes3.messageBox(
            "[The Colored Doors ERROR] Your MWSE is out of date!"
            .. " You will need to update to a more recent version to use this mod."
        )
    end
    event.register("initialized", warning)
    event.register("loaded", warning)
    return
end
----------------------------

-- Check Magicka Expanded framework.
local framework = include("OperatorJack.MagickaExpanded.magickaExpanded")
if (framework == nil) then
    local function warning()
        tes3.messageBox(
            "[The Colored Doors ERROR] Magicka Expanded framework is not installed!"
            .. " You will need to install it to use this mod."
        )
    end
    event.register("initialized", warning)
    event.register("loaded", warning)
    return
end
----------------------------

require("TheVoloptuousVelks-MMM2020.modules.diseases")
require("TheVoloptuousVelks-MMM2020.modules.traps")
require("TheVoloptuousVelks-MMM2020.modules.magic")
require("TheVoloptuousVelks-MMM2020.modules.skybox")
require("TheVoloptuousVelks-MMM2020.modules.mwscript-overrides")
require("TheVoloptuousVelks-MMM2020.modules.quest-events")

local function initialized()
    print("[The Colored Doors: INFO] Initialized")
end
event.register("initialized", initialized)

local function loadTestCell(e)
    if e.isAltDown and tes3.mobilePlayer then
        tes3.positionCell{
            reference = tes3.player,
            cell = "VV20_Test",
            position = {3465, 4330, 12000},
        }

        mwscript.addSpell({
            reference = tes3.player,
            spell = "VV20_SpellAbsorbDisease"
        })
    end
end
event.register("keyDown", loadTestCell, {filter=tes3.scanCode.d})

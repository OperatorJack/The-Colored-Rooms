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

require("TheVoloptuousVelks-MMM2020.modules.diseases")
require("TheVoloptuousVelks-MMM2020.modules.traps")

local function initialized()
    print("[The Colored Doors: INFO] Initialized")
end

event.register("initialized", initialized)
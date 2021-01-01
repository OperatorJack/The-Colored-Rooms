-- Register new effects --
local framework = include("OperatorJack.MagickaExpanded.magickaExpanded")
local common = require("TheVoloptuousVelks-MMM2020.common")

tes3.claimSpellEffectId("absorbDisease", 428)
tes3.claimSpellEffectId("summonAuroran", 429)

local function onTick(e)
	-- Trigger into the spell system.
    if not e:trigger() then
        return
    end

    local target = e.effectInstance.target
    local caster = e.sourceInstance.caster

    for _, spell in pairs(target.object.spells.iterator) do
        if (spell.castType == tes3.spellType.disease) then
            mwscript.addSpell({
                reference = caster,
                spell = spell
            })
            
            mwscript.removeSpell({
                reference = target,
                spell = spell
            })
        end
    end
	e.effectInstance.state = tes3.spellState.retired
end

local function addEffect()
	framework.effects.mysticism.createBasicEffect({
		-- Base information.
		id = tes3.effect.absorbDisease,
		name = "Absorb Disease",
		description = "Absorbs all diseases from the target and gives them to the caster.",

		-- Basic dials.
		baseCost = 16,

		-- Various flags.
		allowEnchanting = true,
        allowSpellmaking = true,
		appliesOnce = true,
		canCastTarget = true,
        canCastTouch = true,
        canCastSelf = false,
        nonRecastable = true,
		hasNoDuration = true,
		hasNoMagnitude = true,

		-- Graphics/sounds.
        lighting = { 255, 223, 255 },

		castSound = "Restoration Cast",
		boltSound = "Restoration Bolt",
		hitSound = "Restoration Hit",
		areaSound = "Restoration Area",

        -- Required callbacks.
        onTick = onTick,
    })

	framework.effects.conjuration.createBasicSummoningEffect({
		id = tes3.effect.summonAuroran,
		name = "Summon Auroran",
		description = "This effect summons an Auroran from The Colored Rooms."..
    " It appears six feet in front of the caster and attacks any entity that attacks the caster until"..
    " the effect ends or the summoning is killed. At death, or when the effect ends, the summoning"..
    " disappears, returning to Oblivion. If summoned in town, the guards will attack you and the summoning on sight.",
		baseCost = 48,
		creatureId = "VV20_CreaAuroran",
	})
end

event.register("magicEffectsResolved", addEffect)
-------------------------

local framework = include("OperatorJack.MagickaExpanded.magickaExpanded")

local function registerSpells()
    framework.spells.createBasicSpell({
        id = common.spells.absorbDisease,
        name = "Peryite's Touch",
        effect = tes3.effect.absorbDisease,
        range = tes3.effectRange.touch,
        magickaCost = 10,
    })
    framework.spells.createBasicSpell({
        id = common.spells.summonAuroran,
        name = "Summon Auroran",
        effect = tes3.effect.summonAuroran,
        range = tes3.effectRange.self,
        duration = 60
    })
end
event.register("MagickaExpanded:Register", registerSpells)

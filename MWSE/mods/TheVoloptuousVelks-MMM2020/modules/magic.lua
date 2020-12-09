-- Register new effects --
local framework = include("OperatorJack.MagickaExpanded.magickaExpanded")
local functions = include("OperatorJack.EnhancedLight.functions")

tes3.claimSpellEffectId("absorbDisease", 428)

local function onTick(e)
	-- Trigger into the spell system.
    if not e:trigger() then
        return
    end

    local target = e.effectInstance.target
    local caster = e.sourceInstance.caster

    for _, spell in pairs(target.object.spells) do
        if (spell.castType == tes3.spellType.disease) then
            caster.object.spells:add(spell)
            target.object.spells:remove(spell)
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
		allowEnchanting = false,
        allowSpellmaking = false,
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
end

event.register("magicEffectsResolved", addEffect)
-------------------------

local framework = include("OperatorJack.MagickaExpanded.magickaExpanded")

local function registerSpells()
    framework.spells.createBasicSpell({
        id = "VV20_SpellAbsorbDisease",
        name = "Absorb Disease",
        effect = tes3.effect.absorbDisease,
        range = tes3.effectRange.touch,
        magickaCost = 75,
    })
end
event.register("MagickaExpanded:Register", registerSpells)

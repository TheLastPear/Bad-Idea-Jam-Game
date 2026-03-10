class_name BMath extends Node

static var xp_curve = XPCurve

# Formulas
static var xp_formula = "XP(Level) = 40 + 6 × (Level - 2)^1.5"
static var damage_formula = "round(4 * user_attack_stat * (action_power / 10)) - round(target_defense_stat / 4)"

static func calculate_damage(action : Action, user : ActiveFighter, target) -> int:
	return roundi(4 * user.fighter.stats["attack"] * float(action.strength) / 10.0) - roundi(float(target.fighter.stats["defense"]) / 2.0)

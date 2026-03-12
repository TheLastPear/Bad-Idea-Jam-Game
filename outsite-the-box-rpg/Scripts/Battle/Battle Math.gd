class_name BMath extends Node

static var xp_curve = XPCurve

# Formulas
static var xp_formula = "XP(Level) = 40 + 6 × (Level - 2)^1.5"
static var damage_formula = "round(4 * user_attack_stat * (action_power / 10)) - round(target_defense_stat / 4)"
static var crit_formula = "(damage_formula + round(target_defense_stat / 4)) * (1 + 1 / 3)"
static var crit_chance = "1 / (20 - round(user_luck_stat / 2))"

static func calculate_damage(action : Action, user : ActiveFighter, target : ActiveFighter) -> int:
	var damage = roundi(4 * user.fighter.stats["attack"] * float(action.strength) / 10.0) - roundi(float(target.fighter.stats["defense"]) / 2.0)
	var will_crit = randi_range(1, 20 - roundi(float(user.fighter.stats["luck"]) / 2.0))
	if will_crit == 1:
		damage = (damage + roundi(float(target.fighter.stats["defense"]) / 2.0)) * (1 + 1.0 / 3.0)
	return damage

class_name BMath extends Node

static var xp_curve := XPCurve

# Formulas
static var xp_formula = "XP(Level) = 40 + 6 × (Level - 2)^1.5"
static var damage_formula = "round(user_attack_stat / ((user_defense_stat + 100) / 100) * (action_strength / 20))"
static var crit_formula = "(damage_formula * (1 + 1 / 3)"
static var crit_chance = "1 / (20 - round(user_luck_stat / 2))"

static func calculate_damage(action : Action, user : ActiveFighter, target : ActiveFighter) -> int:
	var damage = roundi(float(user.fighter.stats["attack"]) / float((target.fighter.stats["defense"] + 100) / 100.0) * (float(action.strength) / 20.0))
	if damage < 1:
		damage = 1
	
	var will_crit = randi_range(1, 20 - roundi(float(user.fighter.stats["luck"]) / 2.0))
	if will_crit == 1:
		damage = roundi(damage * (1 + 1.0 / 3.0))
	
	return damage

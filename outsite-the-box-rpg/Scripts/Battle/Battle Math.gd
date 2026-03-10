class_name BMath extends Resource

static var xp_curve = XPCurve.new()

# Formulas
static var xp_formula = "XP(Level) = 40 + 6 × (Level - 2)^1.5"

static func calculate_damage(action : Action, user, target) -> int:
	var ret_hp = target.fighter.hp
	
	return ret_hp

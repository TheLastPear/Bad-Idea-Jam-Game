class_name BaseStats extends Resource

@export var stat_curve: Curve

@export var stats: Dictionary[String, int] = {
	"health": 0,
	"stamina": 0,
	"attack": 0,
	"defense": 0,
	"speed": 0,
	"luck": 0
}

func calculate_stats(level: int) -> Dictionary[String, int]:
	var ret: Dictionary[String, int] = {}
	var stat_names = ["health", "attack", "defense", "speed", "luck"]
	for stat in stat_names:
		ret[stat] = roundi(stats[stat] * stat_curve.sample(level))
	
	return ret

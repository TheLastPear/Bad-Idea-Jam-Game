class_name BaseStats extends Resource

@export var levelCurve: Curve

@export var stats: Dictionary[String, int] = {
	"health": 0,
	"attack": 0,
	"defense": 0,
	"speed": 0,
	"luck": 0
}


func CalculateStats(level: int) -> Dictionary[String, int]:
	var ret: Dictionary[String, int] = {}
	var statNames = ["health", "attack", "defense", "speed", "luck"]
	for stat in statNames:
		ret.get_or_add(stat, stats[stat] * levelCurve.sample(level))
	
	return ret

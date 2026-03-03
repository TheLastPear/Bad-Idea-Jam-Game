class_name Fighter extends Resource

@export var fighterName: String
@export var description: String
@export var baseStats: BaseStats

@export_group("Stats")
@export var level: int = 1:
	set(value):
		if value == level: return
		level = value
		AssignStats()
@export var exp: int = 0

@export var stats: Dictionary[String, int] = {
	"health": 0,
	"attack": 0,
	"defense": 0,
	"speed": 0,
	"luck": 0
}
@export var statBonuses: Dictionary[String, int] = {
	"health": 0,
	"attack": 0,
	"defense": 0,
	"speed": 0,
	"luck": 0
}:  
	set(value):
		if value == statBonuses: return
		statBonuses = value
		AssignStats()

@export_group("Attacks")
@export var action1: Action
@export var action2: Action

func AssignStats() -> void:
	var newStats = baseStats.CalculateStats(level)
	for key in newStats:
		newStats[key] += statBonuses[key]
	
	stats = newStats
	pass

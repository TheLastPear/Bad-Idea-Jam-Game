class_name Fighter extends Resource

@export var fighter_name : String
@export var description : String
@export var base_stats : BaseStats

@export_group("Stats")
@export var level := 1:
	set(value):
		if value == level: return
		level = value
		assign_stats()
@export var exp := 0
@export var stats := {
	"health": 0,
	"attack": 0,
	"defense": 0,
	"speed": 0,
	"luck": 0
}
@export var stat_bonuses := {
	"health": 0,
	"attack": 0,
	"defense": 0,
	"speed": 0,
	"luck": 0
}:  
	set(value):
		if value == stat_bonuses: return
		stat_bonuses = value
		assign_stats()

@export_group("Attacks")
@export var action_1 : Action
@export var action_2 : Action

func assign_stats() -> void:
	var new_stats = base_stats.calculate_stats(level)
	for key in new_stats:
		new_stats[key] += stat_bonuses[key]
	
	stats = new_stats
	pass

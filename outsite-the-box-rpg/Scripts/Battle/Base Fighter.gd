class_name Fighter extends Resource

signal level_up

@export var fighter_name : String
@export var description : String
@export var base_stats : BaseStats

@export_group("Stats")
@export var hp : int:
	set(v):
		if v == hp: return
		clampi(v, 0, stats["health"])
		hp = v

@export var bp : int
@export var level := 1:
	set(value):
		if value == level: return
		level = value
		assign_stats()

@export var exp := 0:
	set(v):
		if v == exp: return
		if v >= next_exp:
			v -= next_exp
			level_up.emit()
			exp = v

@export var next_exp := BattleMath.xp_curve.get_xp_for_level(level + 1):
	get():
		return BattleMath.xp_curve.get_xp_for_level(level + 1)

@export var stats := {
	"health": 0,
	"stamina": 0,
	"attack": 0,
	"defense": 0,
	"speed": 0,
	"luck": 0
}
@export var stat_bonuses := {
	"health": 0,
	"stamina": 0,
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
@export var basic_attack : Action
@export var action_1 : Action
@export var action_2 : Action

func assign_stats() -> void:
	var new_stats = base_stats.calculate_stats(level)
	for key in new_stats:
		new_stats[key] += stat_bonuses[key]
	
	stats = new_stats
	pass

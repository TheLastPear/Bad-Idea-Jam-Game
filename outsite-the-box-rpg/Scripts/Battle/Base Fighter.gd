class_name Fighter extends Resource

signal level_up

@export var fighter_name : String
@export var description : String
@export var base_stats : BaseStats
@export var is_dead := false

@export_group("Stats")
@export var hp : int:
	set(v):
		if v == hp: return
		clampi(v, 0, stats["health"])
		hp = v

@export var bp : int:
	set(v):
		if v == bp: return
		clampi(v, 0, stats["stamina"])
		bp = v

@export var level := 1:
	set(v):
		if v == level: return
		clampi(v, 1, 20)
		level = v
		assign_stats()

@export var exp := 0:
	set(v):
		if v == exp: return
		clampi(v, 0, BattleMath.xp_curve.get_cumulative_xp(BattleMath.xp_curve.max_level) - BattleMath.xp_curve.get_cumulative_xp(level))
		var can_level = true
		while can_level == true:
			if v >= next_exp:
				v -= next_exp
				level += 1
				level_up.emit()
				exp = v
			else:
				can_level = false
				exp = v

@export var next_exp : int:
	get():
		next_exp = BattleMath.xp_curve.get_xp_for_level(level + 1)
		return next_exp

@export var stats : Dictionary[String, int] = {
	"health": 0,
	"stamina": 0,
	"attack": 0,
	"defense": 0,
	"speed": 0,
	"luck": 0,
}

@export var stat_bonuses : Dictionary[String, int] = {
	"health": 0,
	"stamina": 0,
	"attack": 0,
	"defense": 0,
	"speed": 0,
	"luck": 0
}:
	set(v):
		if v == stat_bonuses: return
		stat_bonuses = v
		assign_stats()

@export_group("Attacks")
@export var basic_attack : Action
@export var specials : Array[Action]


func assign_stats():
	var old_stats := stats
	var new_stats := base_stats.calculate_stats(level)
	for key in new_stats:
		new_stats[key] += stat_bonuses[key]
	
	if !is_dead:
		hp += new_stats["health"] - old_stats["health"]
	
	bp += new_stats["stamina"] - old_stats["stamina"]
	
	stats = new_stats
	pass

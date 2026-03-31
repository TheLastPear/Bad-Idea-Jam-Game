class_name Fighter extends Resource

signal level_up
signal status_update

@export var fighter_name : String
@export var description : String
@export var texture : Texture2D
@export var base_stats : BaseStats
var status_ui : Control
var is_dead := false

var hp : int:
	set(v):
		if v == hp: return
		clampi(v, 0, stats["health"])
		hp = v
		if status_ui:
			if !status_update.is_connected(status_ui.update_status):
				status_update.connect(status_ui.update_status)
			status_update.emit()

var bp : int:
	set(v):
		if v == bp: return
		clampi(v, 0, stats["stamina"])
		bp = v
		if status_ui:
			if !status_update.is_connected(status_ui.update_status):
				status_update.connect(status_ui.update_status)
			status_update.emit()

@export var level := 1:
	set(v):
		if v == level: return
		clampi(v, 1, 20)
		level = v
		assign_stats()

var xp := 0

var next_exp : int:
	get():
		next_exp = BattleMath.xp_curve.get_xp_for_level(level + 1)
		return next_exp

var stats : Dictionary[String, int] = {
	"health": 0,
	"stamina": 0,
	"attack": 0,
	"defense": 0,
	"speed": 0,
	"luck": 0,
}

var stat_bonuses : Dictionary[String, int] = {
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

var exp_to_give : int

@export_group("Attacks")
@export var basic_attack : Action
var specials : Array[Action]
@export var learnset : Dictionary[int, Action]


func assign_stats():
	var old_stats := stats
	var new_stats := base_stats.calculate_stats(level)
	for key in new_stats:
		new_stats[key] += stat_bonuses[key]
	
	if !is_dead:
		hp += new_stats["health"] - old_stats["health"]
	
	bp += new_stats["stamina"] - old_stats["stamina"]
	
	stats = new_stats
	
	exp_to_give = roundi(base_stats.exp_to_give * base_stats.stat_curve.sample(level))
	
	specials.clear()
	for key in learnset:
		if key <= level:
			specials.append(learnset[key])
		else: break
	pass


func gain_exp(value : int):
	if level == XPCurve.max_level: return
	xp += value
	
	var old_stats := stats
	
	var can_level = true
	while can_level == true:
		if xp >= next_exp:
			xp -= next_exp
			level += 1
		else:
			can_level = false
	
	if old_stats != stats:
		level_up.emit.call_deferred(old_stats, stats)
	
	pass

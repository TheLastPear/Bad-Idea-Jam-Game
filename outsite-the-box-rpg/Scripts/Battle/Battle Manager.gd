class_name BattleManager extends Node

@export var battle_speed : float:
	set(value):
		clampf(value, 0.5, 4)
		battle_speed = value

@export var ally_data : Array[Fighter]
@export var enemy_data : Array[Fighter]
@export var active_allies : Array[ActiveFighter]
@export var active_enemies : Array[ActiveFighter]
var turn_order : Array[Fighter]
var selected_actions : Dictionary[Fighter, Action]


func _ready() -> void:
	set_fighters(ally_data, enemy_data) # For loading a battle without passing fighters
	pass


func set_fighters(allies : Array[Fighter], enemies : Array[Fighter]) -> void:
	ally_data = allies
	enemy_data = enemies
	
	var a = 0
	while a < active_allies.size():
		if a < ally_data.size():
			active_allies[a].fighter = ally_data[a]
		else:
			active_allies[a].free()
			active_allies.remove_at(a)
			continue
		
		active_allies[a].move_in()
		a += 1
		pass
	
	var b = 0
	while b < active_enemies.size():
		if b < enemy_data.size():
			active_enemies[b].fighter = enemy_data[b]
		else:
			active_enemies[b].free()
			active_enemies.remove_at(b)
			continue
		
		active_enemies[b].move_in()
		b += 1
		pass
	
	pass

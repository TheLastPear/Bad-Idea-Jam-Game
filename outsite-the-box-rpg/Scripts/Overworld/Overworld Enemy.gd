class_name OverworldEnemy extends Node2D

@export var area_info : AreaInfo
@export var stored_enemies : Array[Fighter]
@export var is_static := false
@onready var player : Node2D = $"../../Environment/Objects/player"


func _ready() -> void:
	if !is_static:
		$StateMachine.on_transition("enemyidle")
	
	if PlayerInfo.area_enemies.has(get_path()):
		if PlayerInfo.area_enemies[get_path()] == false:
			queue_free()
			return
	else:
		PlayerInfo.area_enemies.get_or_add(get_path(), true)
	
	if position.distance_to(player.position) <= 100:
		var dir = position.direction_to(player.position)
		position += dir * -100
	
	if area_info:
		if stored_enemies.size() == 0:
			var roll = randi_range(1, 10)
			var enemy_count := 1
			if roll <= 1:
				enemy_count = PlayerInfo.party.size()
			elif roll <= 3:
				enemy_count = PlayerInfo.party.size() - 1
			elif roll <= 6:
				enemy_count = PlayerInfo.party.size() - 2
			else:
				enemy_count = PlayerInfo.party.size() - 3
			
			stored_enemies.resize(clampi(enemy_count, 1, 4))
			
			for i in stored_enemies.size():
				stored_enemies[i] = area_info.potential_enemies.pick_random()
				stored_enemies[i].level = randi_range(area_info.level_range[0], area_info.level_range[1])
				pass
	pass


func on_area_enter(body : Node2D):
	if body == player:
		PlayerInfo.is_world_frozen = true
		PlayerInfo.opposing_overworld_enemy = get_path()
		PlayerInfo.opposing_party = stored_enemies
		PlayerInfo.current_overworld_scene = get_tree().current_scene.scene_file_path
		PlayerInfo.current_overworld_position = body.position
		SceneLoader.load_scene("res://Scenes/Battle.tscn")
	pass

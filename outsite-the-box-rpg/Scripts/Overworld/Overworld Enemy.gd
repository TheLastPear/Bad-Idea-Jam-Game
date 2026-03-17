extends Node

@export var area_info : AreaInfo
@export var stored_enemies : Array[Fighter]
@onready var player := $"/root/Node2D/player"


func _ready() -> void:
	if area_info:
		if stored_enemies.size() == 0:
			var roll = randi_range(1, 10)
			if roll == 1:
				stored_enemies.resize(4)
			elif roll < 4:
				stored_enemies.resize(3)
			elif roll < 7:
				stored_enemies.resize(2)
			else:
				stored_enemies.resize(1)
			
			for i in stored_enemies.size():
				stored_enemies[i] = area_info.potential_enemies.pick_random()
				pass
	pass


func on_area_enter(body : Node2D):
	if body == player:
		SceneLoader.load_scene("res://Scenes/Battle.tscn")
	pass

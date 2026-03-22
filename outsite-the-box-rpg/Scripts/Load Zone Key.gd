extends Node

# Name of the scene and then the path of the loading zone
var scene_key : SceneKeys = preload("res://Resources/scene_keys.tres")
@onready var keys := scene_key.keys


func _ready() -> void:
	prepare_zones()
	pass


func prepare_zones() -> void:
	await get_tree().process_frame
	for key in keys:
		for path in key.key:
			if !$"..".get_child(-1).has_node(path): continue
			var parent = $"..".get_child(-1).get_node(path)
			
			var zone = parent.get_child(0) as Area2D
			if !zone:
				push_error("Zone not found at " + str(path) + ".")
				continue
			
			zone.body_entered.connect(zone_enter.bind(parent))
	pass


func zone_enter(body : Node2D, emitter : Node2D):
	var emitter_path = $"..".get_child(-1).get_path_to(emitter)
	var this_key
	if body.name == "player":
		var player = $/root.get_child(-1).get_node("player")
		player.locked_movement = true
		for key in keys:
			for path in key.key:
				if path == emitter_path:
					this_key = key
					break
			if this_key:
				break
		
		SceneLoader.load_scene(this_key.key[emitter_path])
		await SceneLoader.load_finished
		await get_tree().process_frame
		var next_zone
		for path in this_key.key:
			if path != emitter_path:
				next_zone = $"..".get_child(-1).get_node(path)
		
		player = $/root.get_child(-1).get_node("player")
		
		player.position = next_zone.position + next_zone.transform.y * 80
		
		player.locked_movement = false
	pass

class_name Defeat extends State

@export var on_enter : AudioStreamPlayer

func enter():
	is_active = true
	get_child(0).show()
	pass


func exit():
	is_active = false
	get_child(0).hide()
	pass


func _input(event: InputEvent) -> void:
	if !is_active: return
	
	if event.is_action_pressed("action") or event.is_action_pressed("back"):
		PlayerInfo.current_overworld_position = PlayerInfo.last_heal_position
		SceneLoader.load_scene(PlayerInfo.current_overworld_scene)
	pass

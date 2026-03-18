class_name OptionSelect extends State

@export var on_next : AudioStreamPlayer
@export var on_return : AudioStreamPlayer


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
	
	if event.is_action_pressed("action"):
		transition.emit("targetselect")
		$"../TargetSelect".loaded_action = controller.current_fighter.fighter.basic_attack
		$"../TargetSelect".previous_window = "optionselect"
		on_next.play()
	elif event.is_action_pressed("special_action"):
		transition.emit("specialselect")
		on_next.play()
	elif event.is_action_pressed("Inventory_open_close"):
		transition.emit("itemselect")
		on_next.play()
	elif event.is_action_pressed("view_party"):
		transition.emit("summaryview")
		on_next.play()
	elif event.is_action_pressed("run_away"):
		SceneLoader.load_scene(PlayerInfo.current_overworld_scene)
		on_return.play()
		print("running")
	pass

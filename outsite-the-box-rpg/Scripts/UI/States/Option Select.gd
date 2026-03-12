extends State


func enter():
	
	pass


func exit():
	
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		transition.emit("target select")
		
	elif event.is_action_pressed("special_action"):
		transition.emit("special select")
		
	elif event.is_action_pressed("Inventory_open_close"):
		transition.emit("item Select")
		
	elif event.is_action_pressed("run_away"):
		print("running")
	pass

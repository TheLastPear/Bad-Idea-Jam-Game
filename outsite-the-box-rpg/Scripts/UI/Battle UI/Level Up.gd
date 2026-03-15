class_name LevelUp extends State

signal done

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
		transition.emit("hidden")
		done.emit()
	pass


func on_poll() -> void:
	if is_active: return
	
	done.emit()
	pass

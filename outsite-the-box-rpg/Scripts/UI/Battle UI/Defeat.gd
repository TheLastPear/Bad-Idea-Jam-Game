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

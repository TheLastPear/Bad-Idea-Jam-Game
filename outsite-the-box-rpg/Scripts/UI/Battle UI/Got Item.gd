class_name GotItem extends State

signal done

@export var label : Label
@export var on_next : AudioStreamPlayer

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
		done.emit()
	pass

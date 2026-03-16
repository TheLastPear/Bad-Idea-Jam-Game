class_name LevelUp extends State

signal done

@export var on_next : AudioStreamPlayer

var old_stats : Dictionary[String, int]
var new_stats : Dictionary[String, int]

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
		on_next.play()
	pass


func on_poll() -> void:
	if is_active: return
	
	done.emit()
	pass

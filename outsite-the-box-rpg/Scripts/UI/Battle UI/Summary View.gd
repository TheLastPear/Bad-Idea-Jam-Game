class_name SummaryView extends State

@export var on_return : AudioStreamPlayer

var fighter_data : Fighter


func enter():
	fighter_data = controller.current_fighter.fighter
	
	get_child(0).show()
	pass


func exit():
	get_child(0).hide()
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		transition.emit("optionselect")
		on_return.play()
	pass

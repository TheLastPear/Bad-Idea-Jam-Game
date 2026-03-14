class_name SpecialSelect extends State

@export var target_state : State
@export var buttons : Array[Button]
var actions : Array[Action]
var loaded_action

func enter():
	get_child(0).show()
	
	actions = controller.current_fighter.fighter.actions
	
	var i = 0
	while i < buttons.size():
		if !actions[i]:
			buttons[i].hide()
			continue
		buttons[i].text = actions[i].action_name
		buttons[i].connect("pressed", assign_action(i)) # assigning the index here might not work
		pass
	pass


func exit():
	get_child(0).hide()
	pass


func assign_action(index : int):
	transition.emit("targetselect")
	$"../TargetSelect".loaded_action = actions[index]
	$"../TargetSelect".previous_window = "specialselect"
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		transition.emit("optionselect")
	pass

extends State

@export var target_state : State
@export var buttons : Array[Button]
var actions : Array[Action]
var loaded_action

func enter():
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
	
	pass


func assign_action(index : int):
	transition.emit("target select")
	$"../Target Select".loaded_action = actions[index]
	$"../Target Select".previous_window = "special select"
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		transition.emit("option select")
	pass

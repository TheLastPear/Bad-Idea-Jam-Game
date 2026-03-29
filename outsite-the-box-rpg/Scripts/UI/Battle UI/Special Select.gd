class_name SpecialSelect extends State

@export var on_next : AudioStreamPlayer
@export var on_return : AudioStreamPlayer

@export var target_state : State
@export var buttons : Array[Button]
var actions : Array[Action]
var selected_action := 0
var loaded_action


func enter():
	is_active = true
	get_child(0).show()
	
	actions = controller.current_fighter.fighter.specials
	
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
	is_active = false
	get_child(0).hide()
	pass


func assign_action(index : int):
	if !is_active: return
	
	transition.emit("targetselect")
	$"../TargetSelect".loaded_action = actions[index]
	$"../TargetSelect".previous_window = "specialselect"
	on_next.play()
	pass


func _input(event: InputEvent) -> void:
	if !is_active: return
	
	if event.is_action_pressed("back"):
		transition.emit("optionselect")
		on_return.play()
	elif event.is_action_pressed("action"):
		assign_action(selected_action)
	
	if event.is_action_pressed("movement_up"):
		selected_action = Utils.subtract_and_wrap(selected_action, -1, actions.size())
	elif event.is_action_pressed("movement_down"):
		selected_action = Utils.add_and_wrap(selected_action, actions.size() + 1, 0)
	pass

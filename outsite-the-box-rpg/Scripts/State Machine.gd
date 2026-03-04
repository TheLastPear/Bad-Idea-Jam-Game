class_name StateMachine extends Node

@export var current_state : State
@export var initial_state : State
var states : Dictionary[String, State]


func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition.connect(on_transition)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state
	pass


func on_transition(state : State, new_state_name : String):
	if state == current_state: return
	
	var new_state = states[new_state_name.to_lower()]
	if !new_state: return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
	pass

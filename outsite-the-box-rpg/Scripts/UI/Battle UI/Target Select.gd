class_name TargetSelect extends State

@export var battle_manager : BattleManager
var loaded_action : Action
var current_target : int
var targets : Array[ActiveFighter]
var previous_window : String

func enter():
	is_active = true
	get_child(0).show()
	
	targets.clear()
	targets.append_array(battle_manager.active_enemies)
	pass


func exit():
	is_active = false
	get_child(0).hide()
	pass


func _input(event: InputEvent) -> void:
	if !is_active: return
	
	if event.is_action_pressed("action"):
		battle_manager.attack_phase(loaded_action, targets[current_target]) # must pass the action and the target
		
	elif event.is_action_pressed("back"):
		transition.emit(previous_window)
		
	elif event.is_action_pressed("movement_up"):
		if current_target == 0:
			current_target = targets.size() - 1
		else:
			current_target -= 1
		
	elif event.is_action_pressed("movement_down"):
		if current_target == targets.size() - 1:
			current_target = 0
		else:
			current_target += 1
		
	elif event.is_action_pressed("movement_left"):
		if current_target == 0:
			current_target = targets.size() - 1
		else:
			current_target -= 1
		
	elif event.is_action_pressed("movement_right"):
		if current_target == targets.size() - 1:
			current_target = 0
		else:
			current_target += 1
	pass

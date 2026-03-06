class_name ActiveFighter extends Node2D

signal has_slid_in
signal action_finished

enum Alignment {
	ally,
	enemy,
}

@export var fighter : Fighter:
	set(value):
		fighter = value
		fighter.assign_stats()

@export var alignment : Alignment
@export var actions : Array[Action]


func start() -> void:
	if fighter.basic_attack:
		actions.append(fighter.basic_attack)
	
	if fighter.action_1:
		actions.append(fighter.action_1)
	
	if fighter.action_2:
		actions.append(fighter.action_2)
	
	if alignment == Alignment.ally:
		var button = $Button
		if button:
			button.held_object = get_script() as ActiveFighter
	pass


func move_in():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(position.x + 250 * scale.x, position.y), 0.5)
	
	await tween.finished
	
	has_slid_in.emit()
	pass


func do_action(action : Action):
	print("Doing action: " + action.action_name)
	await get_tree().create_timer(2).timout
	pass

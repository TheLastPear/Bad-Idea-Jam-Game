class_name ActiveFighter extends Control

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
@export var target : ActiveFighter
@export var alignment : Alignment
@export var actions : Array[Action]
@export var manager : BattleManager
var start_position : Vector2


func start() -> void:
	if fighter.basic_attack:
		actions.append(fighter.basic_attack)
	
	if fighter.action_1:
		actions.append(fighter.action_1)
	
	if fighter.action_2:
		actions.append(fighter.action_2)
	pass


func move_in():
	position = Vector2(start_position.x - 250 * scale.x, start_position.y)
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", start_position, 0.5)
	
	await tween.finished
	
	has_slid_in.emit()
	pass


func do_action(action : Action):
	print(name + "is doing action: " + action.action_name)
	
	var to_tween = get_tree().create_tween()
	print(self)
	to_tween.tween_property(self, "position", Vector2(target.position.x + (150 * scale.x * -1), target.position.y), manager.slide_speed)
	await to_tween.finished
	
	await get_tree().create_timer(0.5).timeout
	
	for hit in action.hits:
		target.deal_damage(fighter.stats["attack"], action.strength)
	
	var back_tween = get_tree().create_tween()
	back_tween.tween_property(self, "position", start_position, manager.slide_speed)
	await back_tween.finished
	
	action_finished.emit()
	pass


func deal_damage(atk_stat : int, power : int):
	fighter.
	pass

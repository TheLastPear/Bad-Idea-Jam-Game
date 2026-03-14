class_name ActiveFighter extends Control

signal has_slid_in
signal action_finished

enum Alignment {
	ally,
	enemy,
}

@export var fighter : Fighter
@export var alignment : Alignment
@export var manager : BattleManager
var start_position : Vector2


func move_in():
	fighter.assign_stats()
	
	position = Vector2(start_position.x - 250 * scale.x, start_position.y)
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", start_position, 0.5)
	
	await tween.finished
	
	has_slid_in.emit()
	pass


func do_action(action : Action, target : ActiveFighter):
	print(fighter.fighter_name + " used " + action.action_name)
	
	var to_tween = get_tree().create_tween()
	to_tween.tween_property(self, "position", Vector2(target.position.x + (150 * scale.x * -1), target.position.y), manager.slide_speed)
	await to_tween.finished
	
	await get_tree().create_timer(0.5).timeout
	
	for hit in action.hits:
		target.take_damage(self, action)
	
	var back_tween = get_tree().create_tween()
	back_tween.tween_property(self, "position", start_position, manager.slide_speed)
	await back_tween.finished
	
	action_finished.emit()
	pass


func take_damage(user : ActiveFighter, action : Action):
	var damage = BMath.calculate_damage(action, user, self)
	fighter.hp -= damage
	print(name + " took " + str(damage) + " damage. Remaining hp: " + str(fighter.hp))
	pass

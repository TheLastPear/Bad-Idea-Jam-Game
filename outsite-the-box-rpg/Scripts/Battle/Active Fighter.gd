class_name ActiveFighter extends Control

signal has_slid_in
signal action_finished
@warning_ignore("unused_signal")
signal gained_exp
signal died

enum Alignment {
	ally,
	enemy,
}

@export var fighter : Fighter
@export var alignment : Alignment
@export var manager : BattleManager


func move_in():
	$Sprite2D.texture = fighter.texture
	
	fighter.status_ui = $/root.get_child(-1).get_node("UI/Status Window")
	
	fighter.assign_stats()
	died.connect(manager.check_for_end)
	
	has_slid_in.emit()
	pass


func do_action(action : Action, target : ActiveFighter):
	fighter.bp -= action.used_stamina
	print(fighter.fighter_name + " used " + action.action_name + ". Remaining stamina: " + str(fighter.bp))
	
	await get_tree().create_timer(0.5).timeout
	
	for hit in action.hits:
		target.take_damage(self, action)
	
	action_finished.emit()
	pass


func take_damage(user : ActiveFighter, action : Action):
	var damage = BMath.calculate_damage(action, user, self)
	fighter.hp -= damage
	
	if fighter.hp <= 0:
		die(user)
		return
	
	print(fighter.fighter_name + " took " + str(damage) + " damage. Remaining hp: " + str(fighter.hp))
	pass


func die(user : ActiveFighter):
	manager.turn_order.remove_at(manager.turn_order.find(self))
	if alignment == Alignment.ally:
		manager.active_allies.remove_at(manager.active_allies.find(self))
	else:
		manager.active_enemies.remove_at(manager.active_enemies.find(self))
	print(name + " died")
	if alignment == Alignment.enemy:
		user.fighter.gain_exp(fighter.exp_to_give)
		print(user.name + " gained " + str(fighter.exp_to_give) + " exp")
	
	died.emit()
	
	free.call_deferred()
	pass

class_name BattleManager extends Node

signal poll_level_up

@export_group("Battle Settings")
@export var battle_speed : int:
	set(value):
		clampi(value, 1, 2)
		battle_speed = value
@export var slide_speed : float
@export var text_step : float

@export_group("Variables")
var is_battle_over := false
var current_fighter : ActiveFighter
@export var ally_data : Array[Fighter]
@export var enemy_data : Array[Fighter]
@export var active_allies : Array[ActiveFighter]
@export var active_enemies : Array[ActiveFighter]
var turn_order : Array[ActiveFighter]

@export_group("Wait times")
@export var init_wait_time : float = 1
@export var phase_transition_time : float = 0.5
@export var between_action_time : float = 0.25

@export_group("References")
@export var ui : BattleUIManager
@export var popup : Label
@export var char_positions : Array[Control]

func _ready() -> void:
	if ally_data.size() == 0:
		ally_data = PlayerInfo.party
	
	if enemy_data.size() == 0:
		enemy_data = PlayerInfo.opposing_party
	
	is_battle_over = false
	
	var a = 0
	while a < active_allies.size():
		if a < ally_data.size():
			active_allies[a].fighter = ally_data[a]
			active_allies[a].fighter.level_up.connect(leveled_up)
		else:
			active_allies[a].get_parent().free()
			active_allies.remove_at(a)
			continue
		a += 1
		pass
	
	var b = 0
	while b < active_enemies.size():
		if b < enemy_data.size():
			active_enemies[b].fighter = enemy_data[b]
		else:
			active_enemies[b].get_parent().free()
			active_enemies.remove_at(b)
			continue
		b += 1
		pass
	
	await get_tree().create_timer(init_wait_time).timeout
	
	turn_order.clear()
	turn_order.append_array(active_allies)
	turn_order.append_array(active_enemies)
	turn_order.sort_custom(speed_ascending)
	
	for fighter in turn_order:
		fighter.move_in()
	
	var done := active_allies[0].has_slid_in
	await done
	
	await get_tree().create_timer(phase_transition_time).timeout
	
	planning_phase(-1)
	pass


func planning_phase(index := turn_order.find(current_fighter)):
	if is_battle_over: return
	
	if index == turn_order.size() - 1:
		current_fighter = turn_order[0]
	else:
		current_fighter = turn_order[index + 1]
	print(str(current_fighter.fighter.fighter_name) + "'s turn")
	ui.current_fighter = current_fighter
	
	if current_fighter.alignment == ActiveFighter.Alignment.enemy:
		var loaded_action = ai_choose_action()
		attack_phase(loaded_action, ai_choose_target(loaded_action))
		return
	
	await get_tree().create_timer(phase_transition_time).timeout
	
	ui.on_transition("optionselect")
	pass


func attack_phase(action : Action, target : ActiveFighter):
	if is_battle_over: return
	
	ui.on_transition("hidden")
	await get_tree().create_timer(phase_transition_time).timeout
	
	current_fighter.do_action(action, target)
	
	var action_done = current_fighter.action_finished
	await action_done
	
	var level_up_done = ui.states["levelup"].done
	poll_level_up.emit.call_deferred()
	await level_up_done
	
	planning_phase()
	pass


func check_for_end():
	var level_up_done = ui.states["levelup"].done
	poll_level_up.emit.call_deferred()
	await level_up_done
	
	if active_allies.size() == 0:
		ui.on_transition("defeat")
		is_battle_over = true
	elif active_enemies.size() == 0:
		ui.on_transition("victory")
		PlayerInfo.area_enemies[PlayerInfo.opposing_overworld_enemy] = false
		is_battle_over = true
	pass


# Enemy AI
func ai_choose_action() -> Action: # Expand the ai later
	var options : Array[Action]
	options.append(current_fighter.fighter.basic_attack)
	options.append_array(current_fighter.fighter.specials)
	return options.pick_random()

@warning_ignore("unused_parameter")
func ai_choose_target(action : Action) -> ActiveFighter:
	var target = active_allies.pick_random()
	return target

# Custom Sorts
static func speed_ascending(a, b):
	a = a as ActiveFighter
	b = b as ActiveFighter
	
	if a.fighter.stats["speed"] == b.fighter.stats["speed"]:
		if randi_range(1, 2) == 1:
			return true
		else:
			return false
	elif a.fighter.stats["speed"] < b.fighter.stats["speed"]:
		return false
	else:
		return true


# UI
func leveled_up(old_stats, stats):
	ui.on_transition("levelup")
	ui.states["levelup"].old_stats = old_stats
	ui.states["levelup"].new_stats = stats
	pass


func set_text(text : String, skip_char_time := false):
	popup.text = text
	
	if !skip_char_time:
		popup.visible_characters = 0
		for _char in popup.text:
			await get_tree().create_timer(text_step).timeout
			popup.visible_characters += 1
	pass

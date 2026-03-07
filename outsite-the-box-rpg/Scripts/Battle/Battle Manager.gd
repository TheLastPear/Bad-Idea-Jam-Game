class_name BattleManager extends Node

signal on_planning_phase
signal undo_action_select
signal hide_buttons
signal show_buttons
signal set_button

enum Phase {
	attack_phase,
	plan_phase,
	victory_phase,
}

@export_group("Battle Settings")
@export var battle_speed : float:
	set(value):
		clampf(value, 0.5, 4)
		battle_speed = value

@export_group("Variables")
@export var current_phase : Phase
@export var selected_fighter : ActiveFighter
@export var ally_data : Array[Fighter]
@export var enemy_data : Array[Fighter]
@export var active_allies : Array[ActiveFighter]
@export var active_enemies : Array[ActiveFighter]
var turn_order : Array[ActiveFighter]
var selected_actions : Dictionary[ActiveFighter, Action]

@export_group("Wait times")
@export var phase_transition_time : float = 0.5
@export var between_action_time : float = 0.25

@export_group("References")
@export var main_ui : Control
@export var action_buttons : Array[Button]
@export var action_description : RichTextLabel
@onready var sound_cancel = $"/root/Battle/UI Audio/back"

func _ready() -> void:
	set_fighters(ally_data, enemy_data) # For loading a battle without passing fighters
	change_phase(Phase.plan_phase)
	pass


func set_fighters(allies : Array[Fighter], enemies : Array[Fighter]) -> void:
	ally_data = allies
	enemy_data = enemies
	
	var a = 0
	while a < active_allies.size():
		if a < ally_data.size():
			active_allies[a].fighter = ally_data[a]
			var button = active_allies[a].get_child(1)
			set_button.connect(button.set_held_item)
			set_button.emit(active_allies[a])
		else:
			active_allies[a].free()
			active_allies.remove_at(a)
			continue
		
		active_allies[a].start()
		active_allies[a].move_in()
		a += 1
		pass
	
	var b = 0
	while b < active_enemies.size():
		if b < enemy_data.size():
			active_enemies[b].fighter = enemy_data[b]
		else:
			active_enemies[b].free()
			active_enemies.remove_at(b)
			continue
		
		active_enemies[b].start()
		active_enemies[b].move_in()
		b += 1
		pass
	
	pass


func change_phase(to_phase : Phase):
	await get_tree().create_timer(phase_transition_time).timeout
	current_phase = to_phase
	
	match current_phase:
		Phase.plan_phase:
			planning_phase()
		Phase.attack_phase:
			attack_phase()
	pass


func planning_phase():
	print("Make your move")
	for fighter in active_allies:
			selected_actions.get_or_add(fighter)
			pass
	
	while selected_actions[active_allies[active_allies.size() - 1]] == null:
		await get_tree().process_frame
	
	change_phase(Phase.attack_phase)
	pass


func attack_phase():
	print("Attacking")
	turn_order.clear()
	turn_order.append_array(active_allies)
	turn_order.append_array(active_enemies)
	turn_order.sort_custom(speed_ascending)
	
	for enemy in active_enemies:
		selected_actions.get_or_add(enemy, ai_choose_action(enemy))
		pass
	
	for fighter in turn_order:
		fighter.do_action(selected_actions[fighter])
		await fighter.action_finished
		print("Next attack")
		await get_tree().create_timer(between_action_time).timeout
		pass
	
	pass


func change_selected_fighter(fighter : ActiveFighter):
	selected_fighter = fighter
	
	var i = 0
	while i < action_buttons.size():
		var button = action_buttons[i]
		if selected_fighter.actions[i]:
			button.show()
			button.held_object = selected_fighter.actions[i]
			button.text = button.held_object.action_name
		else:
			button.hide()
	
	pass


func assign_action(action : Action):
	selected_actions[selected_fighter] = action
	pass


func ai_choose_action(fighter : ActiveFighter) -> Action: # Expand the ai later
	return fighter.actions.pick_random()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and selected_fighter != active_allies[0] and main_ui.is_visible_in_tree():
		selected_actions[selected_fighter] = null
		undo_action_select.emit()
		print("Action select undone")
	pass

# Custom Sorts
func speed_ascending(a, b):
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
func on_hide_buttons():
	hide_buttons.emit()
	pass


func on_show_buttons():
	show_buttons.emit()
	pass

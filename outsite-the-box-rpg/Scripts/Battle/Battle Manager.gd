class_name BattleManager extends Node

signal on_planning_phase
signal undo_action_select
signal set_button

enum Phase {
	attack_phase,
	plan_phase,
	victory_phase,
}

enum Selecting {
	character,
	option,
	summary,
	item,
	action,
	target,
}

@export_group("Battle Settings")
@export var battle_speed : int:
	set(value):
		clampi(value, 1, 2)
		battle_speed = value
@export var slide_speed : float
@export var text_step : float

@export_group("Variables")
@export var current_input : Selecting
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
@export var dialogue : RichTextLabel
@export var action_buttons : Array[Button]
@export var char_positions : Array[Control]
@export var ally_buttons : Array[Button]
@export var enemy_buttons : Array[Button]
@export var action_description : RichTextLabel
@export var sound_cancel : AudioStreamPlayer

func _ready() -> void:
	selecting_character()
	
	var a = 0
	while a < active_allies.size():
		if a < ally_data.size():
			active_allies[a].fighter = ally_data[a]
			active_allies[a].start_position = char_positions[a].position + Vector2(30, 30)
			
			var button = ally_buttons[a]
			set_button.connect(button.get_fighter)
			set_button.emit(active_allies[a])
			set_button.disconnect(button.get_fighter)
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
			active_enemies[b].start_position = char_positions[4 + b].position  + Vector2(30, 30)
			
			var button = enemy_buttons[b]
			set_button.connect(button.get_fighter)
			set_button.emit(active_enemies[b])
			set_button.disconnect(button.get_fighter)
		else:
			active_enemies[b].free()
			active_enemies.remove_at(b)
			continue
		
		active_enemies[b].start()
		active_enemies[b].move_in()
		b += 1
		pass
	
	change_phase(Phase.plan_phase)
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
	on_show_buttons()
	
	for fighter in active_allies:
		fighter.target = null
	
	selected_actions.clear()
	
	for fighter in active_allies:
			selected_actions.get_or_add(fighter)
			pass
	
	var has_chosen_targets := false
	while !has_chosen_targets:
		if active_allies.all(func(element): return element.target != null):
			has_chosen_targets = true
		await get_tree().process_frame
	
	change_phase(Phase.attack_phase)
	pass


func attack_phase():
	print("Attacking")
	on_hide_buttons()
	
	turn_order.clear()
	turn_order.append_array(active_allies)
	turn_order.append_array(active_enemies)
	turn_order.sort_custom(speed_ascending)
	
	for enemy in active_enemies:
		selected_actions.get_or_add(enemy, ai_choose_action(enemy))
		pass
	
	await get_tree().create_timer(between_action_time).timeout
	
	for fighter in turn_order:
		fighter.do_action(selected_actions[fighter])
		
		set_text(fighter.fighter.fighter_name + " used " + selected_actions[fighter].action_name)
		
		var done = fighter.action_finished
		await done
		await get_tree().create_timer(between_action_time).timeout
		pass
	
	change_phase(Phase.plan_phase)
	pass


func change_selected_fighter(fighter : ActiveFighter):
	selected_fighter = fighter
	
	if selected_actions[selected_fighter]:
		set_text(selected_fighter.fighter.fighter_name + " is going to use " + selected_actions[selected_fighter].action_name + ".", true)
	else:
		set_text(selected_fighter.fighter.fighter_name + " does not know what to do.", true)
	
	var i = 0
	while i < action_buttons.size():
		var button = action_buttons[i]
		if selected_fighter.actions[i]:
			button.show()
			button.held_object = selected_fighter.actions[i]
			button.text = button.held_object.action_name
		else:
			button.hide()
		
		i += 1
		pass
	pass


func assign_action(action : Action):
	selected_actions[selected_fighter] = action
	print("Assigned action " + selected_actions[selected_fighter].action_name + " to " + selected_fighter.fighter.fighter_name)
	pass


func assign_target(target : ActiveFighter):
	selected_fighter.target = target
	print("Assigned " + target.name + " as the target.")
	pass


func ai_choose_action(fighter : ActiveFighter) -> Action: # Expand the ai later
	fighter.target = active_allies.pick_random()
	return fighter.actions.pick_random()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if current_input == Selecting.character:
			selected_actions[selected_fighter] = null
			change_selected_fighter(selected_fighter)
			print("Action select undone")
		elif current_input == Selecting.target:
			selected_actions[selected_fighter] = null
	pass

# Setting current_input
func selecting_character():
	current_input = Selecting.character

func selecting_option():
	current_input = Selecting.option

func selecting_summary():
	current_input = Selecting.summary

func selecting_item():
	current_input = Selecting.item

func selecting_action():
	current_input = Selecting.action

func selecting_target():
	current_input = Selecting.target

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
func set_text(text : String, skip_char_time := false):
	dialogue.text = text
	
	if !skip_char_time:
		dialogue.visible_characters = 0
		for _char in dialogue.text:
			await get_tree().create_timer(text_step).timeout
			dialogue.visible_characters += 1
	pass

func on_hide_buttons():
	for button in ally_buttons:
		print("hide attempt")
		button.hide()
	pass


func on_show_buttons():
	for button in ally_buttons:
		print("show attempt")
		button.show()
	pass


func on_show_enemy_buttons():
	for button in enemy_buttons:
		button.hide()
	pass


func on_hide_enemy_buttons():
	for button in enemy_buttons:
		button.show()
	pass

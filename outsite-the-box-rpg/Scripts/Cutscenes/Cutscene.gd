@tool class_name Cutscene extends Node

@export_tool_button("New Dialogue") var add_dialogue = new_dialogue

@export_tool_button("New Option Dialogue") var add_option_dialogue = new_option

@export_tool_button("New Action") var add_action = new_action

#region Editor
func new_dialogue():
	var property : PackedScene = load("res://Scenes/Loads/Cutscene/AdvanceBox.tscn")
	var node = property.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	add_child(node, true)
	node.owner = get_tree().edited_scene_root
	node.hide()
	pass


func new_option():
	var property : PackedScene = load("res://Scenes/Loads/Cutscene/AdvanceBox.tscn")
	var node = property.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	add_child(node, true)
	node.owner = get_tree().edited_scene_root
	node.hide()
	pass


func new_action():
	var property : PackedScene = load("res://Scenes/Loads/Cutscene/AdvanceBox.tscn")
	var node = property.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	add_child(node, true)
	node.owner = get_tree().edited_scene_root
	node.hide()
	pass
#endregion

func start():
	PlayerInfo.is_world_frozen = true
	
	var steps = get_children()
	for step in steps:
		step.enter()
		var done = step.next
		await done
	
	PlayerInfo.is_world_frozen = false
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("run_away"):
		start()
	pass

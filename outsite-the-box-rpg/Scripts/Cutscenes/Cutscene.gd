@tool class_name Cutscene extends Node

signal done
signal next_cutscene

@export_tool_button("New Dialogue") var add_dialogue = new_dialogue

@export_tool_button("New Option Dialogue") var add_option_dialogue = new_option

@export_tool_button("New Action") var add_action = new_action

@export_tool_button("New Cutscene Branch") var add_branch = new_branch

var current_child : Node

#region Editor
func new_dialogue():
	var property : PackedScene = load("res://Scenes/Loads/Cutscene/AdvanceBox.tscn")
	var node = property.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	add_child(node, true)
	node.owner = get_tree().edited_scene_root
	node.hide()
	pass


func new_option():
	var property : PackedScene = load("res://Scenes/Loads/Cutscene/OptionBox.tscn")
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


func new_branch():
	var property : PackedScene = load("res://Scenes/Loads/Cutscene/Cutscene.tscn")
	var node = property.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	add_child(node, true)
	node.scene_file_path = ""
	node.owner = get_tree().edited_scene_root
	if node is Control:
		node.hide()
	pass

#endregion

func start():
	if get_parent() is Cutscene:
		next_cutscene.connect(get_parent().next_node)
	
	get_children()[0].start()
	pass


func exit():
	pass


func next_node(caller : Node, next = null):
	current_child = caller
	caller.exit()
	var caller_index = get_children().find(caller)
	if next:
		var next_index = get_children().find(next)
		get_children()[next_index].start()
	elif caller_index != get_children().size() - 1 and caller is Control:
		get_children()[caller_index + 1].start()
	else:
		if next_cutscene.has_connections():
			next_cutscene.emit(self)
		else:
			done.emit()
	pass

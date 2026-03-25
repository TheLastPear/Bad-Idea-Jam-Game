@tool extends Control

signal on_start
signal done

@export_tool_button("New Tween") var add_tween = new_tween

var tweens_finished := 0


func new_tween():
	var node = TweenNode.new()
	add_child(node, true)
	node.owner = get_tree().edited_scene_root


func _enter_tree() -> void:
	scene_file_path = ""
	owner = get_tree().edited_scene_root
	pass


func exit():
	pass


func start():
	on_start.emit()
	
	done.connect(get_parent().next_node)
	
	tweens_finished = 0
	while tweens_finished < get_child_count():
		await get_tree().process_frame
	
	done.emit(self)
	pass


func tween_done():
	tweens_finished += 1
	pass

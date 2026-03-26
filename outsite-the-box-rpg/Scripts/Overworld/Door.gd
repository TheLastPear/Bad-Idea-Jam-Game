@tool extends Interactable

@export_range(1000, 9999, 1) var id = randi_range(1000, 9999)
@export var cutscene : Cutscene


func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	if player:
		player.interact.connect(on_interact)
	
	if PlayerInfo.player_keys.has(id):
		if PlayerInfo.player_keys[id]:
			if PlayerInfo.player_keys[id][1]:
				queue_free()
	else:
		PlayerInfo.player_keys.get_or_add(id, [false, false])
	pass


func do_function():
	if !PlayerInfo.player_keys[id][0]:
		PlayerInfo.is_world_frozen = true
		cutscene.start()
		var done = cutscene.done
		await done
		await get_tree().create_timer(0.1).timeout
		PlayerInfo.is_world_frozen = false
		return
	
	await get_tree().create_timer(1).timeout # replace this with the animation_finished signal
	PlayerInfo.player_keys[id][1] = true
	queue_free()
	pass

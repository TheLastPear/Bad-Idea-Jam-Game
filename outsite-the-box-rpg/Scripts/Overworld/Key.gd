extends Interactable

@export var id : int
@export var cutscene : Cutscene

func do_function():
	PlayerInfo.is_world_frozen = true
	cutscene.start()
	var done = cutscene.done
	await done
	await get_tree().create_timer(0.1).timeout
	PlayerInfo.is_world_frozen = false
	PlayerInfo.player_keys[id].set(0, true)
	queue_free()
	pass

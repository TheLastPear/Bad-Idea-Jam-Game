extends Interactable

@export var cutscene_to_play : Cutscene


func do_function():
	print("Interacted")
	if cutscene_to_play:
		PlayerInfo.is_world_frozen = true
		cutscene_to_play.start()
	else:
		push_warning("This NPC has no attached function")
	
	var done = cutscene_to_play.done
	await done
	
	PlayerInfo.is_world_frozen = true
	pass

extends Interactable

@export var id : int

func do_function():
	print("Collected key")
	PlayerInfo.player_keys[id].set(0, true)
	queue_free()
	pass

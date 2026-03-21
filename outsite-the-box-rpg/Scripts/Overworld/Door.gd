@tool extends Node2D

@export_range(1000, 9999, 1) var id = randi_range(1000, 9999)
@onready var player : Node2D = $"/root/Base/player"


func _ready() -> void:
	if PlayerInfo.player_keys.has(id):
		if PlayerInfo.player_keys[id]:
			if PlayerInfo.player_keys[id][1]:
				queue_free()
			else:
				await_open()
	else:
		PlayerInfo.player_keys.get_or_add(id, [false, false])
	pass


func await_open():
	while position.distance_to(player.position) > 200:
		await get_tree().process_frame
	
	await get_tree().create_timer(1).timeout # replace this with the animation_finished signal
	print("opened")
	PlayerInfo.player_keys[id][1] = true
	queue_free()
	pass

extends Node2D

@export var id : int
@onready var player := $"/root/Base/player"


func _ready() -> void:
	await get_tree().process_frame
	
	if !PlayerInfo.player_keys.has(id):
		push_warning("Key at " + str(get_path()) + " does not have an id that is listed in the global dictionary.")
	pass


func on_contact(body : Node):
	if body == player:
		print("Collected")
		PlayerInfo.player_keys[id][0] = true
		queue_free()
	pass

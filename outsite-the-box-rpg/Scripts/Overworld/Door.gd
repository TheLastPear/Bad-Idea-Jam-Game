extends Node2D

@export var keys : Array[Key]


func _ready() -> void:
	if PlayerInfo.player_keys.has(get_path()):
		pass
	pass

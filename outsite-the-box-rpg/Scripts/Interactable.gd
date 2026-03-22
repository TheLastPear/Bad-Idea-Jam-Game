class_name Interactable extends StaticBody2D

@export var player : Player


func _ready() -> void:
	if player:
		player.interact.connect(on_interact)
	pass

@warning_ignore("unused_parameter")
func on_interact(binding):
	if binding == self:
		do_function()
	pass


func do_function():
	pass

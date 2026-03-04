class_name ActiveFighter extends Node2D

@export var fighter : Fighter:
	set(value):
		fighter = value
		fighter.assign_stats()


func move_in():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(position.x + 250 * scale.x, position.y), 0.5)
	pass

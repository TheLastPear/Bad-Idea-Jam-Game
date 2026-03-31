extends ProgressBar

@export var target : ActiveFighter


func _process(delta: float) -> void:
	if target:
		max_value = target.fighter.stats["health"]
		value = target.fighter.hp
	pass

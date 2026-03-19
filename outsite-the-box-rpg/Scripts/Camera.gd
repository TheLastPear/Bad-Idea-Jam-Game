extends Camera2D

@export var target : Node2D


func _ready() -> void:
	if target:
		position_smoothing_enabled = false
		position = target.position
		await get_tree().process_frame
		position_smoothing_enabled = true
	pass


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if !target: return
	
	position = target.position
	pass

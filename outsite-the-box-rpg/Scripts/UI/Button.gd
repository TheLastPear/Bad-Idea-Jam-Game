extends Button

@export var start_with_focus : bool
signal on_pressed


func _ready() -> void:
	if is_visible_in_tree() and start_with_focus:
		grab_focus.call_deferred()
	pass


func _pressed() -> void:
	on_pressed.emit(self)
	pass

extends Button

@onready var on_focused = $"/root/Battle/UI Audio/main"

@export var start_with_focus : bool


func _ready() -> void:
	focus_exited.connect(on_focused.play)
	
	if is_visible_in_tree() and start_with_focus:
		grab_focus.call_deferred()
	pass

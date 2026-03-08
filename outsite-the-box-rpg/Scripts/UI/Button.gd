class_name CustomButton extends Button

signal pass_on_press
signal pass_on_focus

@export var on_focused : AudioStreamPlayer
@export var on_pressed : AudioStreamPlayer

@export var start_with_focus : bool
var held_object


func _ready() -> void:
	focus_entered.connect(on_focus)
	
	if on_focused != null:
		focus_exited.connect(on_focused.play)
	if on_pressed != null:
		pressed.connect(on_pressed.play)
	
	if is_visible_in_tree() and start_with_focus:
		grab_focus.call_deferred()
	pass


func _pressed():
	pass_on_press.emit(held_object)
	pass


func _grab_focus():
	grab_focus.call_deferred()
	pass


func on_focus():
	if held_object:
		pass_on_focus.emit(held_object)
	pass


func set_held_object(object):
	held_object = object
	pass


func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED and start_with_focus:
		grab_focus.call_deferred()
	pass

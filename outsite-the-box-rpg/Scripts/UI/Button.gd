class_name CustomButton extends Button

signal pass_on_press
signal pass_on_focus

@export var on_focused : AudioStreamPlayer

@export var start_with_focus : bool
var held_object:
	set(value):
		held_object = value
		print(held_object)


func _ready() -> void:
	focus_entered.connect(on_focus)
	
	if on_focused != null:
		focus_exited.connect(on_focused.play)
	
	if is_visible_in_tree() and start_with_focus:
		grab_focus.call_deferred()
	pass


func set_held_item(object):
	held_object = object
	print("item stored in " + str(self.get_path()))
	pass


func _pressed():
	pass_on_press.emit(held_object)
	pass


func _grab_focus():
	grab_focus.call_deferred()
	pass


func on_focus():
	if held_object:
		print("passed")
		pass_on_focus.emit(held_object)
	pass


func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED and start_with_focus:
		grab_focus.call_deferred()
	pass

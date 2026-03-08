extends Control

@export var on_back : AudioStreamPlayer

@export var previous_window : Control
@export var first_focus : Control
signal on_return
signal on_open

func _ready() -> void:
	if on_back:
		on_return.connect(on_back.play)
	if previous_window != null:
		on_return.connect(previous_window.open_window)
	pass


func open_window() -> void:
	self.show()
	if first_focus != null:
		first_focus.grab_focus.call_deferred()
	on_open.emit()
	pass


func return_to_other_window() -> void:
	self.hide()
	on_return.emit.call_deferred()
	pass


func next_window() -> void:
	self.hide()
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and previous_window != null and is_visible_in_tree():
		return_to_other_window()
	pass


func _on_button_pressed() -> void:
	pass # Replace with function body.

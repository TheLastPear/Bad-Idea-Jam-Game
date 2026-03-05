extends Control

@onready var on_back = $"/root/Battle/UI Audio/back"

@export var previous_window : Control
@export var first_focus : Control
signal on_return

func _ready() -> void:
	on_return.connect(on_back.play)
	if previous_window != null:
		on_return.connect(previous_window.open_window)
	pass


func open_window() -> void:
	self.show()
	if first_focus != null:
		first_focus.grab_focus()
	pass


func return_to_other_window() -> void:
	self.hide()
	on_return.emit()
	pass


func next_window() -> void:
	self.hide()
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and previous_window != null and is_visible_in_tree():
		return_to_other_window()
	pass

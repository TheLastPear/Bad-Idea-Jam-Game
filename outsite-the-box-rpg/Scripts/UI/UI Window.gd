extends Control

var focus_memory : Button


func _ready() -> void:
	
	pass


func open_window(from : Button) -> void:
	focus_memory = from
	
	self.show()
	
	for child in get_children():
		if child is Button:
			var button = child as Button
			button.grab_focus()
			print("Focus grabbed")
			break
	
	pass


func return_to_other_window() -> void:
	self.hide()
	
	focus_memory.grab_focus()
	pass


func next_window() -> void:
	self.hide()
	pass

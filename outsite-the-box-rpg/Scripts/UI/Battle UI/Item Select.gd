class_name ItemSelect extends State

@export var items : Array[InvItem]


func enter():
	is_active = true
	get_child(0).show()
	pass


func exit():
	is_active = false
	get_child(0).hide()
	pass


func assign_item(index : int):
	if !is_active: return
	
	transition.emit("allyselect")
	$"../AllySelect".loaded_action = UseItem
	$"../AllySelect".loaded_action.item = items[index]
	$"../AllySelect".previous_window = "itemselect"
	pass


func _input(event: InputEvent) -> void:
	if !is_active: return
	
	if event.is_action_pressed("back"):
		transition.emit("optionselect")
	pass

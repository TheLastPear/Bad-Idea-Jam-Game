@tool extends Control

signal next
signal on_choose(option : String)

@export var speaker : Texture2D
@export var collucuter : Texture2D
@export_enum("MC", "Sister", "Letter from Mom") var speaker_name : String
@export var text : String
@export var options : Dictionary[String, Node]
@export var text_speed := 0.1
@onready var name_text : Label = $MarginContainer/VBoxContainer/HBoxContainer/SpeakerName
@onready var dialogue_text : Label = $MarginContainer/VBoxContainer/Dialogue
@onready var options_parent = $MarginContainer/VBoxContainer/HBoxContainer2
@onready var manager = get_parent()

var selected_option = 0
var is_active := false
var was_skipped := false
var can_advance := false

func start():
	is_active = true
	
	if !next.is_connected(manager.next_node):
		next.connect(manager.next_node)
	
	var labels = options_parent.get_children() as Array[Label]
	for i in options.keys().size():
		if i > labels.size():
			var label = Label.new()
			options_parent.add_child(label)
			labels.append(label)
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		labels[i].text = options.keys()[i]
		labels[i].hide()
	
	show()
	handle_text()
	pass


func exit():
	is_active = false
	hide()
	pass


func handle_text():
	name_text.text = speaker_name
	dialogue_text.text = text
	
	was_skipped = false
	can_advance = false
	dialogue_text.visible_characters = 0
	while dialogue_text.visible_characters < dialogue_text.text.length():
		await get_tree().create_timer(text_speed).timeout
		dialogue_text.visible_characters += 1
		if was_skipped: break
		pass
	
	can_advance = true
	dialogue_text.visible_characters = -1
	
	for child in options_parent.get_children():
		child.show()
	pass


func _input(event: InputEvent) -> void:
	if !is_active: return
	
	if event.is_action_pressed("movement_left"):
		selected_option = Utils.subtract_and_wrap(selected_option, -1, options.keys().size() - 1)
	elif event.is_action_pressed("movement_right"):
		selected_option = Utils.add_and_wrap(selected_option, options.keys().size(), 0)
	
	if event.is_action_pressed("action"):
		if can_advance:
			on_choose.emit(options.keys()[selected_option])
			next.emit(self, options[options.keys()[selected_option]])
		else:
			was_skipped = true
	pass

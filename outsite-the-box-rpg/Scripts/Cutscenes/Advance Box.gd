extends Control

signal next

@export var speaker : Texture2D
@export var collucuter : Texture2D
@export_enum("MC", "Sister", "Letter from Mom") var speaker_name : String
@export var text : String
@export var text_speed : float = 0.1
@onready var name_text : Label = $MarginContainer/VBoxContainer/HBoxContainer/SpeakerName
@onready var dialogue_text : Label = $MarginContainer/VBoxContainer/Dialogue

var is_active := false
var was_skipped := false
var can_advance := false

func enter():
	is_active = true
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
	pass


func _input(event: InputEvent) -> void:
	if !is_active: return
	
	if event.is_action_pressed("action") or event.is_action_pressed("action"):
		if can_advance:
			next.emit()
			exit()
		else:
			was_skipped = true
	pass

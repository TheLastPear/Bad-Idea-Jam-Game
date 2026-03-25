@tool class_name TweenNode extends Node

signal done

@onready var tween = create_tween()

@export var object_to_tween : Node:
	set(v):
		object_to_tween = v
		object_properties.clear()
		if object_to_tween:
			for property in object_to_tween.get_property_list():
				object_properties.get_or_add(property["name"], property["type"])

var object_properties : Dictionary[String, Variant.Type]

@export var property_to_tween : String

@export var end_value : Variant

@export_range(0.1, 100, 0.1) var duration : float

@export var chain := false

func _ready() -> void:
	tween.stop()
	
	if Engine.is_editor_hint(): return
	
	done.connect(get_parent().tween_done)
	
	if chain:
		var index = get_index() - 1
		if index >= 0 and get_parent().get_child(index) is TweenNode:
			get_parent().get_child(index).done.connect(start)
		else:
			chain = false
			get_parent().on_start.connect(start)
			push_warning("A TweenNode at index 0 cannot chain.")
	else:
		get_parent().on_start.connect(start)
	pass


func start() -> void:
	tween.play()
	tween.tween_property(object_to_tween, property_to_tween, end_value, duration)
	await tween.finished
	done.emit()
	pass

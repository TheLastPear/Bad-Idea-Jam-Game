extends Node

# Name of the scene and then the path of the loading zone
var key : SceneKeys = preload("res://Resources/scene_keys.tres")
@onready var keys : Dictionary[NodePath, String] = key.keys


func _ready() -> void:
	for path in keys:
		var parent = get_node(path)
		if !parent:
			push_error("Object not found at " + str(path) + ".")
			continue
		
		var zone = parent.get_child(0) as Area2D
		if !zone:
			push_error("Zone not found at " + str(path) + ".")
			continue
		
		zone.body_entered.connect(zone_enter.bind(parent))
	pass


func zone_enter(body : Node2D, emitter : Node):
	if body.get_parent().get_script() is Player:
		SceneLoader.load_scene(keys[emitter.get_path()])
	pass

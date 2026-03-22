extends Node

signal load_finished

var loading_screen : PackedScene = preload("res://Scenes/loading_screen.tscn")
var loaded_resource : PackedScene
var zone_to_exit : Node2D
var scene_path : String
var use_sub_threads : bool = true


func _ready() -> void:
	set_process(false)
	pass


func load_scene(new_scene_path : String) -> void:
	scene_path = new_scene_path
	
	var new_loading_screen = loading_screen.instantiate()
	add_child(new_loading_screen)
	load_finished.connect(new_loading_screen.on_load_finished)
	
	await new_loading_screen.loading_screen_ready
	
	start_load()
	pass


func start_load() -> void:
	var state = ResourceLoader.load_threaded_request(scene_path, "", use_sub_threads)
	if state == OK:
		set_process(true)
	pass

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	var load_status = ResourceLoader.load_threaded_get_status(scene_path)
	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			set_process(false)
		ResourceLoader.THREAD_LOAD_LOADED:
			loaded_resource = ResourceLoader.load_threaded_get(scene_path)
			get_tree().change_scene_to_packed(loaded_resource)
			load_finished.emit()
			$"../LoadZoneKey".prepare_zones()
	pass

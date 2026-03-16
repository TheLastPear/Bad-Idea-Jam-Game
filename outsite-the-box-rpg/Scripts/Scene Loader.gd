extends Node

signal progress_changed(progress : float)
signal load_finished

var load_screen : PackedScene = null
var loaded_resource : PackedScene
var scene_path : String

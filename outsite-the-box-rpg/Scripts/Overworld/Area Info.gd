class_name AreaInfo extends Node

@export var potential_enemies : Array[Fighter]
@export var level_range : Array[int] = [1, 1]
@export var opening_cutscene : Cutscene


func _ready() -> void:
	if !PlayerInfo.entered_areas.keys().has(get_path()):
		PlayerInfo.entered_areas.get_or_add(get_path(), false)
	
	if opening_cutscene and !PlayerInfo.entered_areas[get_path()]:
		PlayerInfo.is_world_frozen = true
		opening_cutscene.start()
	
	PlayerInfo.entered_areas[get_path()] = true
	
	if opening_cutscene:
		var done = opening_cutscene.done
		await done
	
	PlayerInfo.is_world_frozen = false
	pass

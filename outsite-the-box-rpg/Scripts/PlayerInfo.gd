extends Node

var current_overworld_scene
var current_overworld_position : Vector2:
	set(v):
		current_overworld_position = v
		print(v)
var last_heal_position : Vector2
var area_enemies : Dictionary[NodePath, bool]
var entered_areas : Dictionary[NodePath, bool]

var party : Array[Fighter] = [preload("res://Resources/Fighters/Allies/Player Fighter.tres")]
var inventory : Inv = preload("res://Scripts/inventory/playerinv.tres")
var player_keys : Dictionary[int, Array]
var is_world_frozen := false

var opposing_overworld_enemy : NodePath
var opposing_party : Array[Fighter]

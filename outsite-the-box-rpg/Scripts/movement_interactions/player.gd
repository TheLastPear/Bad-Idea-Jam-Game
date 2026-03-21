class_name Player extends CharacterBody2D

@export var speed = 400

@export var inv: Inv

@export var camera : Camera2D

func _ready() -> void:
	if !PlayerInfo.current_overworld_position:
		PlayerInfo.current_overworld_position = position
	
	position = PlayerInfo.current_overworld_position


func get_input():
	var input_direction = Input.get_vector("movement_left","movement_right","movement_up","movement_down")
	velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()


func collect(item):
	inv.insert(item)

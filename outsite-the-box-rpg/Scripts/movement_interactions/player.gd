extends CharacterBody2D

@export var speed = 400


@export var inv: Inv

func get_input():
	var input_direction = Input.get_vector("movement_left","movement_right","movement_up","movement_down")
	velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()

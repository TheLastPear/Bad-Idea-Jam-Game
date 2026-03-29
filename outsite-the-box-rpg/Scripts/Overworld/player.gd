class_name Player extends CharacterBody2D

signal interact

@export var speed = 400

@export var inv: Inv

@export var camera : Camera2D

@onready var ray : RayCast2D = $"RayCast2D"

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if !PlayerInfo.current_overworld_position:
		PlayerInfo.current_overworld_position = position
	
	position = PlayerInfo.current_overworld_position
	
	if !PlayerInfo.last_heal_position:
		PlayerInfo.current_overworld_position = position
	pass


func get_input():
	var input_direction = Input.get_vector("movement_left","movement_right","movement_up","movement_down")
	if input_direction != Vector2.ZERO:
		ray.look_at(ray.global_position + input_direction)
		ray.rotation = ray.rotation - PI / 2
	velocity = input_direction * speed
	
	if velocity.y > 0:
		sprite.play("walk_down")
	elif velocity.y < 0:
		sprite.play("walk_up")
	elif velocity.x > 0:
		sprite.play("walk_right")
	elif velocity.x < 0:
		sprite.play("walk_left")
	
	if velocity.length() == 0:
		if sprite.animation == "walk_up":
			sprite.play("idle_up")
		elif sprite.animation == "walk_down":
			sprite.play("idle_down")
		elif sprite.animation == "walk_left":
			sprite.play("idle_left")
		elif sprite.animation == "walk_right":
			sprite.play("idle_right")
	
	# Interactions
	if Input.is_action_just_pressed("action"):
		var other = ray.get_collider()
		if other is CollisionObject2D:
			if other.get_collision_layer_value(2):
				interact.emit(other)

func _physics_process(_delta):
	if !PlayerInfo.is_world_frozen:
		get_input()
	else:
		velocity = Vector2.ZERO
	move_and_slide()


func collect(item):
	inv.insert(item)

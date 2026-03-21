class_name EnemyChase extends State

@export var this : CharacterBody2D
@export var area : Area2D
@onready var player : CharacterBody2D
@export var speed : int
@export var sight_distance : int
@export var spotted_delay : float
var caught_player := false

func enter():
	player = this.player
	await get_tree().create_timer(spotted_delay).timeout
	chase()
	pass


func exit():
	
	pass


func chase():
	var distance_to_player = (player.position - this.position).length()
	while distance_to_player <= sight_distance and !caught_player:
		distance_to_player = (player.position - this.position).length()
		var direction = this.position.direction_to(player.position)
		this.move_and_collide(direction * speed * get_process_delta_time())
		await get_tree().process_frame
	
	await get_tree().create_timer(spotted_delay).timeout
	
	transition.emit("enemyidle")
	pass

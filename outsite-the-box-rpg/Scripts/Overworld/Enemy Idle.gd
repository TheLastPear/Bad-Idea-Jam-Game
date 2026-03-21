class_name EnemyIdle extends State

@export var this : CharacterBody2D
@onready var player : CharacterBody2D
@export var sight_distance : int
@export var speed : int
var spotted_player := false
var start_position : Vector2


func _ready() -> void:
	start_position = this.position
	pass


func enter():
	player = this.player
	idle()
	pass


func idle():
	while !spotted_player:
		await get_tree().create_timer(randi_range(1, 3)).timeout
		var tween = get_tree().create_tween()
		
		var direction : Vector2
		if this.position.distance_to(start_position) > 200:
			direction = this.position.direction_to(start_position)
		else:
			direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		
		var distance = randi_range(20, 100)
		
		tween.tween_property(this, "position", this.position + direction * distance, 2)
		
		while tween.is_running():
			if this.position.distance_to(player.position) <= sight_distance:
				tween.kill()
				transition.emit("enemychase")
				break
			await get_tree().process_frame
		await get_tree().process_frame
	pass

extends CharacterBody2D
# can change speed if too slow or fast but this is just a place holder
@export var speed = 400
# this code is just simple movement that let you move the charcter 8 way so you can use two keys to move diagonanly
func get_input():
	var input_direction = Input.get_vector("movement_left","movement_right","movement_up","movement_down")
	velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()

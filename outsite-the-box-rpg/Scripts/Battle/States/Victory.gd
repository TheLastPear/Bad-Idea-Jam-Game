class_name VictoryState extends State

@export var wait_time : float


func enter():
	await get_tree().create_timer(wait_time).timeout
	print("Victory!")
	pass

class_name State extends Node

@warning_ignore("unused_signal")
signal transition

var is_active := false
@onready var controller : StateMachine = get_parent()

func enter():
	pass


func exit():
	pass

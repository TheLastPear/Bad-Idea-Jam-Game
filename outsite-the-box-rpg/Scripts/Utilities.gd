class_name Utils extends Node

## Use this to navigate down arrays.
static func add_and_wrap(value : int, wrap_at : int, wrap_to : int) -> int:
	var new_value = value + 1
	if new_value >= wrap_at:
		new_value = wrap_to
	return new_value


## Use this to navigate up arrays.
static func subtract_and_wrap(value : int, wrap_at : int, wrap_to : int) -> int:
	var new_value = value - 1
	if new_value <= wrap_at:
		new_value = wrap_to
	return new_value

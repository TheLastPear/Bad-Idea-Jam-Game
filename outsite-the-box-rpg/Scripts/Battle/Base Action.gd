class_name Action extends Resource

enum Type {
	attack,
	heal,
	mod # Maybe
}

@export var action_name : String
@export var description : String
@export var type := Type.attack
@export var used_stamina : int
@export var hits := 1
@export var strength := 0
@export var heal := 0
var modifier := 0
var stacks := 0

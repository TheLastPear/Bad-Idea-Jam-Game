class_name Action extends Resource

enum Type {
	attack,
	heal,
	mod # Maybe
}

@export var actionName: String
@export var description: String
@export var type: Type = Type.attack
@export var hits: int = 1
@export var strength: int = 0
@export var heal: int = 0
@export var speed: int = 0
var modifier = 0
var stacks: int = 0

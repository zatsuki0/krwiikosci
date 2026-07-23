extends Resource
class_name LimbData

enum LimbType {
	HEAD,
	TORSO,
	ARM,
	LEG,
	TAIL
}

@export var limb_type: LimbType

@export var max_health: float = 100.0
@export var health: float = 100.0

@export var runes: Array[String] = []
@export var rune_capacity: int = 1
@export var mutations: Array[String] = []
@export var injury: Array[String] = []

@export var missing: bool = false

extends Resource
class_name PlayerData


@export var name: String = "Unknown"
@export var background: String = "Unknown"
var health: float = 100.0 # placeholder updated by limbs
var agility: float = 10.0 # placeholder updated by limbs
@export var inventory: Array[String] = []

func initialize():
	if inventory == null:
		inventory = []

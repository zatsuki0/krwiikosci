extends Resource
class_name PlayerData


@export var name: String = "Unknown"
@export var background: String = "Unknown"

var base_stats: Dictionary = {
	Stats.Type.VITALITY: 0,
	Stats.Type.VIGOUR: 0,
	Stats.Type.RESILIENCE: 0,
	Stats.Type.COMPREHENSION: 0,
	Stats.Type.FEROCITY: 0,
	Stats.Type.SUSCEPTIBILITY: 0
}

var health: float = 100.0 # placeholder updated by limbs
@export var inventory: Array[String] = []

func initialize():
	if inventory == null:
		inventory = []

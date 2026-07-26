extends Resource
class_name LimbData

enum LimbType {
	HEAD,
	TORSO,
	ARM,
	LEG,
	TAIL
}

@export_category("Identification")

@export var id: String
@export var display_name: String
@export_multiline var description: String

@export_category("Stats")

@export var vitality: int = 0
@export var vigour: int = 0
@export var resilience: int = 0
@export var comprehension: int = 0
@export var ferocity: int = 0
@export var susceptibility: int = 0

var stats := {
	Stats.Type.VITALITY: null,
	Stats.Type.VIGOUR: null,
	Stats.Type.RESILIENCE: null,
	Stats.Type.COMPREHENSION: null,
	Stats.Type.FEROCITY: null,
	Stats.Type.SUSCEPTIBILITY: null
}

func get_stat(stat: Stats.Type) -> int:
	update_stats()
	return stats.get(stat)

func update_stats():
	stats = {
		Stats.Type.VITALITY: vitality,
		Stats.Type.VIGOUR: vigour,
		Stats.Type.RESILIENCE: resilience,
		Stats.Type.COMPREHENSION: comprehension,
		Stats.Type.FEROCITY: ferocity,
		Stats.Type.SUSCEPTIBILITY: susceptibility
	}

@export_category("Other")

@export var limb_type: LimbType

var health: float = 0

var runes: Array[String] = []
@export var rune_capacity: int = 1
@export var mutation_capacity: int = 1

var mutations: Array[String] = []
var injury: Array[String] = []

var missing: bool = false

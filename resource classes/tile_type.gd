@tool
extends Resource
class_name TileType

enum EdgeType {
	WALL,
	OPEN,
	DOOR
}

@export_range(0, 10, 0.05) var weight : float = 1.0
var base_weight: float = -1.0

@export_group('Specification')
@export_subgroup("Identification")
@export var id : int
@export var tile_name : String

# Connection edges
@export_subgroup("Edges")
@export var north : EdgeType = EdgeType.WALL
@export var east : EdgeType = EdgeType.WALL
@export var south : EdgeType = EdgeType.WALL
@export var west : EdgeType = EdgeType.WALL

# Visual data
@export_subgroup("Texture")
@export var texture : Texture2D

func get_edge(direction : int) -> EdgeType:
	match direction:
		0:
			return north
		1:
			return east
		2:
			return south
		3:
			return west
	
	return EdgeType.WALL

func door_directions():
	var directions = []
	if north == 2: directions.append("north")
	if south == 2: directions.append("south")
	if east == 2: directions.append("east")
	if west == 2: directions.append("west")
	return directions
	
func open_directions():
	var directions = []
	if north == 1: directions.append("north")
	if south == 1: directions.append("south")
	if east == 1: directions.append("east")
	if west == 1: directions.append("west")
	return directions

func wall_directions():
	var directions = []
	if north == 0: directions.append("north")
	if south == 0: directions.append("south")
	if east == 0: directions.append("east")
	if west == 0: directions.append("west")
	return directions

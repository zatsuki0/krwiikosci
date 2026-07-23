@tool
extends Resource
class_name TileDatabase

var base_weights := {}

@export_category("Weight based on door number")

var _one := 1.5
@export_range(0,10,0.05)
var one:
	get:
		return _one
	set(value):
		_one = value
		_refresh_weights()

var _two := 1.0
@export_range(0,10,0.05)
var two:
	get:
		return _two
	set(value):
		_two = value
		_refresh_weights()

var _three := 0.5
@export_range(0,10,0.05)
var three:
	get:
		return _three
	set(value):
		_three = value
		_refresh_weights()

var _four := 0.3
@export_range(0,10,0.05)
var four:
	get:
		return _four
	set(value):
		_four = value
		_refresh_weights()

@export_category("Modifiers")

var _one_missing := 0.5
@export_range(0,3,0.05)
var one_missing:
	get:
		return _one_missing
	set(value):
		_one_missing = value
		_refresh_weights()

var _two_missing := 0.4
@export_range(0,3,0.05)
var two_missing:
	get:
		return _two_missing
	set(value):
		_two_missing = value
		_refresh_weights()

var _three_missing := 0.3
@export_range(0,3,0.05)
var three_missing:
	get:
		return _three_missing
	set(value):
		_three_missing = value
		_refresh_weights()


@export_category("Resource database")

@export_group("Special")
@export var special:Array[TileType] = []

@export_group("4 walls")
@export var one_door:Array[TileType] = []
@export var two_doors:Array[TileType] = []
@export var three_doors:Array[TileType] = []
@export var four_doors:Array[TileType] = []

@export_group("3 walls")
@export var missing_north:Array[TileType] = []
@export var missing_east:Array[TileType] = []
@export var missing_south:Array[TileType] = []
@export var missing_west:Array[TileType] = []

@export_group("2 walls")
@export var two_missing_tiles:Array[TileType] = []

@export_group("1 wall")
@export var three_missing_tiles:Array[TileType] = []


func _refresh_weights():

	base_weights.clear()

	# All tiles get their natural weight from door count
	_set_base(one_door)
	_set_base(two_doors)
	_set_base(three_doors)
	_set_base(four_doors)

	_set_base(missing_north)
	_set_base(missing_east)
	_set_base(missing_south)
	_set_base(missing_west)

	_set_base(two_missing_tiles)
	_set_base(three_missing_tiles)


	# Apply modifiers afterwards
	_apply_modifier(missing_north, one_missing)
	_apply_modifier(missing_east, one_missing)
	_apply_modifier(missing_south, one_missing)
	_apply_modifier(missing_west, one_missing)

	_apply_modifier(two_missing_tiles, two_missing)
	_apply_modifier(three_missing_tiles, three_missing)
	
	
func _set_base(tiles: Array[TileType], value: float = -1):
	for tile in tiles:
		if not base_weights.has(tile):
			
			if value == -1:
				var door_count = tile.door_directions().size()

				match door_count:
					1:
						base_weights[tile] = one
					2:
						base_weights[tile] = two
					3:
						base_weights[tile] = three
					4:
						base_weights[tile] = four
					_:
						base_weights[tile] = 1.0
			
			else:
				base_weights[tile] = value
		
		tile.weight = base_weights[tile]
		tile.emit_changed()

func _apply_modifier(tiles: Array[TileType], multiplier: float):
	for tile in tiles:
		if base_weights.has(tile):
			tile.weight = base_weights[tile] * multiplier
			tile.emit_changed()

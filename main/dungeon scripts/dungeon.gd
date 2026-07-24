extends Node
class_name Dungeon


var data: DungeonData

var generator: DungeonGenerator


var width: int
var height: int


func _init(
	width: int = 5,
	height: int = 5
):

	self.width = width
	self.height = height

	generator = DungeonGenerator.new(
		width,
		height
	)



func generate():

	data = await generator.generate()

	return data



func get_cell(pos: Vector2i) -> Cell:

	if data == null:
		return null

	return data.get_cell(pos)



func get_neighbors(pos: Vector2i):

	if data == null:
		return {}

	return data.get_neighbors(pos)



func print_grid(mode: String, border: bool = false):

	if data:
		data.print_grid(mode, border)



func count_non_wall_cells() -> int:

	if data == null:
		return 0

	return data.count_non_wall_cells()

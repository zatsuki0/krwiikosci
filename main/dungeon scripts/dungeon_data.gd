extends Resource
class_name DungeonData


var width: int
var height: int
var grid: Dictionary = {}
var cords_of_starting_cell: Vector2i

var wall_resc = load("res://tiles/special/walls.tres")


func _init(
	width: int = 0,
	height: int = 0,
	starting_cell: Vector2i = Vector2i.ZERO
):
	self.width = width
	self.height = height
	self.cords_of_starting_cell = starting_cell


func print_grid(mode: String, border: bool = false):
	print("--- Current grid ---")

	var offset = 1 if border else 0

	for y in range(-offset, height + offset):
		var row = ""

		for x in range(-offset, width + offset):
			var cell = grid.get(Vector2i(x, y))

			if cell == null:
				row += "null\t"
				continue

			if mode == "entropy":
				if cell.collapsed:
					row += "x\t"
				else:
					row += str(cell.entropy) + "\t"

			elif mode == "rescs":
				if cell.resc:
					row += str(cell.resc.get_path()) + "\t"
				else:
					row += "null\t"

		print(row)


func insert_static_cell(cell: Cell, cords: Vector2i):
	cell.entropy = 1
	cell.collapsed = true
	grid[cords] = cell


func get_cell(cords: Vector2i) -> Cell:
	return grid.get(cords)


func get_neighbors(cords: Vector2i) -> Dictionary:
	var neighbors = {
		"north": null,
		"south": null,
		"west": null,
		"east": null
	}

	if grid.has(cords + Vector2i.UP):
		neighbors["north"] = grid[cords + Vector2i.UP]

	if grid.has(cords + Vector2i.DOWN):
		neighbors["south"] = grid[cords + Vector2i.DOWN]

	if grid.has(cords + Vector2i.LEFT):
		neighbors["west"] = grid[cords + Vector2i.LEFT]

	if grid.has(cords + Vector2i.RIGHT):
		neighbors["east"] = grid[cords + Vector2i.RIGHT]

	return neighbors


func grid_has_flag(flag_name) -> bool:
	for cell in grid.values():
		if cell.flag == flag_name:
			return true

	return false


func count_non_wall_cells() -> int:
	var count := 0

	for cell in grid.values():
		if cell.resc != wall_resc:
			count += 1

	return count

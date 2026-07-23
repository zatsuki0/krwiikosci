class_name Dungeon

var width
var height
var grid = {}
var possible_cell_rescs: Array[Resource] = load_resources('res://tiles/')
var cell_database = load("res://tileDatabase1.tres")
var starting_cell
var wall_cell
var boss_cell
var basic_starting_cell_resc = load("res://tiles/0/NESW0.tres")
var cords_of_starting_cell
var wall_resc = load("res://tiles/special/walls.tres")
var possible_boss_rescs = cell_database.one_door

func _init(Width: int, Height: int, starting_cell_cords: Vector2i, starting_cell_resource: Resource = basic_starting_cell_resc):
	width = Width
	height = Height
	cords_of_starting_cell = starting_cell_cords
	
	# defining of the starting cell
	starting_cell = Cell.new()
	starting_cell.resc = starting_cell_resource
	starting_cell.flag = Cell.Flag.START
	
	# defining of the border cell
	wall_cell = Cell.new()
	wall_cell.resc = wall_resc
	wall_cell.flag = Cell.Flag.BORDER
	
	#defining of the boss cell
	boss_cell = Cell.new()
	boss_cell.resc = possible_boss_rescs.pick_random()
	boss_cell.flag = Cell.Flag.BOSS
	
	create_grid()


func create_grid():
	
	
	# actual grid generation
	for y in range(height):
		for x in range(width):
			var new_cell = Cell.new()
			grid[Vector2i(x, y)] = Cell.new() # default cell
	
	# inserting starting cell 
	insert_static_cell(starting_cell, cords_of_starting_cell)
	
	# inserting boss cell
	#var possible_boss_cords = get_cells_in_range(cords_of_starting_cell, 2)
	var possible_boss_cords = ConnectedCells.get_diamond_ring(grid, cords_of_starting_cell, 2)
	insert_static_cell(boss_cell, possible_boss_cords.pick_random())
	
	# the actual - in code - dictionary of cells has a *border*, which means width+2, height+2
	for x in range(-1, width + 1):
		insert_static_cell(wall_cell, Vector2i(x, -1))
		insert_static_cell(wall_cell, Vector2i(x, height))
	for y in range(0, height):
		insert_static_cell(wall_cell, Vector2i(-1, y))
		insert_static_cell(wall_cell, Vector2i(width, y))
		

func update_cell(cords: Vector2i):
	
	#if global.debug:
	#	print('--------------------')
	#	print('updating cell from cords ', cords)
		
		
	return get_cell(cords).update_entropy(get_neighbors(cords), possible_cell_rescs, cords)


func update_entropies():
	for x in width:
		for y in height:
			update_cell(Vector2i(x,y))


func collapse_lowest_entropy_cell():
	var lowest = INF
	var lowest_cords = Vector2i.ZERO
	
	for y in range(height):
		for x in range(width):
			var pos = Vector2i(x, y)
			var cell = grid[pos]
			
			if cell.collapsed != true:
				if cell.entropy < lowest:
					lowest = cell.entropy
					lowest_cords = pos
	
	if global.debug:
		print("lowest entropy: ", lowest, " pos: ", lowest_cords)
		print(grid[lowest_cords].entropy)
	
	grid[lowest_cords].collapse()

func insert_static_cell(cell: Cell, cords: Vector2i):
	cell.entropy = 1
	cell.collapsed = true
	grid[cords] = cell

func print_grid(mode: String, border: bool = false):
	print("--- Current grid ---")
	var modif = 0
	if border:
		modif = 1
	else:
		modif = 0
	
	
	for y in range(-modif, height + modif):
		var row = ""
		
		for x in range(-modif, width + modif):
			if mode == 'entropy':
				if grid[Vector2i(x, y)].collapsed:
					row += "x\t"
				else:
					row += str(grid[Vector2i(x, y)].entropy) + "\t"
			else:
				if grid[Vector2i(x, y)].resc:
					row += str(grid[Vector2i(x, y)].resc.get_path()) + "\t"
	
		
		print(row)


func get_cell(cords: Vector2i):
	return grid[cords]


func get_neighbors(cords: Vector2i):
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


func get_cells_in_range(center: Vector2i, distance: int) -> Array[Vector2i]:
	var result: Array[Vector2i] = []

	for x in range(center.x - distance, center.x + distance + 1):
		for y in range(center.y - distance, center.y + distance + 1):
			var pos = Vector2i(x, y)

			if abs(x - center.x) + abs(y - center.y) == distance:
				if x >= 0 and x < width and y >= 0 and y < height:
					result.append(pos)

	return result


func load_resources(path: String):
	var resources: Array[Resource] = []
	var main_dir = DirAccess.open(path)

	if main_dir == null:
		print("FAILED:", path)
		return resources

	for folder in main_dir.get_directories():
		var sub_dir = DirAccess.open(path + "/" + folder)

		if sub_dir == null:
			continue

		for file in sub_dir.get_files():
			if file.ends_with(".tres") or file.ends_with(".res"):
				resources.append(load(path + "/" + folder + "/" + file) as TileType)

	return resources


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

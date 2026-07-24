extends RefCounted
class_name DungeonGenerator


var dungeon_width: int
var dungeon_height: int
var starting_cell_cords: Vector2i

var min_room_count: int
var max_room_count: int
var distance_to_boss: int


var possible_cell_rescs: Array[Resource] = load_resources("res://tiles/")
var cell_database = load("res://tileDatabase1.tres")

var basic_starting_cell_resc = load("res://tiles/0/NESW0.tres")
var wall_resc = load("res://tiles/special/walls.tres")

var possible_boss_rescs


var starting_cell: Cell
var wall_cell: Cell
var boss_cell: Cell


var mutex := Mutex.new()
var result_dungeon: DungeonData = null
var threads: Array[Thread] = []


func _init(
	width: int,
	height: int,
	starting_cell_cords: Vector2i = Vector2i(floor(width/2), floor(height/2)),
	starting_cell_resource: Resource = null,
	min_room_count: int = 7,
	max_room_count: int = 20,
	distance_to_boss: int = 3
):

	self.dungeon_width = width
	self.dungeon_height = height
	self.starting_cell_cords = starting_cell_cords

	self.min_room_count = min_room_count
	self.max_room_count = max_room_count
	self.distance_to_boss = distance_to_boss


	if starting_cell_resource == null:
		starting_cell_resource = basic_starting_cell_resc


	possible_boss_rescs = cell_database.one_door


	starting_cell = Cell.new()
	starting_cell.resc = starting_cell_resource
	starting_cell.flag = Cell.Flag.START


	wall_cell = Cell.new()
	wall_cell.resc = wall_resc
	wall_cell.flag = Cell.Flag.BORDER


	boss_cell = Cell.new()
	boss_cell.resc = possible_boss_rescs.pick_random()
	boss_cell.flag = Cell.Flag.BOSS



func generate() -> DungeonData:

	result_dungeon = null
	threads.clear()

	var thread_count := 4


	for i in range(thread_count):
		var thread := Thread.new()
		threads.append(thread)
		thread.start(generate_dungeon_thread)


	while result_dungeon == null:
		await Engine.get_main_loop().process_frame


	for thread in threads:
		thread.wait_to_finish()


	return result_dungeon



func generate_dungeon_thread():

	while true:

		mutex.lock()
		var finished = result_dungeon != null
		mutex.unlock()


		if finished:
			return


		var data := DungeonData.new(
			dungeon_width,
			dungeon_height,
			starting_cell_cords
		)


		create_grid(data)
		generate_dungeon(data)


		if check_dungeon(data):

			mutex.lock()

			if result_dungeon == null:
				result_dungeon = data

			mutex.unlock()

			return



func create_grid(data: DungeonData):

	for y in range(dungeon_height):
		for x in range(dungeon_width):
			data.grid[Vector2i(x,y)] = Cell.new()



	data.insert_static_cell(
		starting_cell,
		starting_cell_cords
	)


	var possible_boss_cords = ConnectedCells.get_diamond_ring(
		data.grid,
		starting_cell_cords,
		2
	)


	data.insert_static_cell(
		boss_cell,
		possible_boss_cords.pick_random()
	)



	# border

	for x in range(-1, dungeon_width + 1):

		data.insert_static_cell(
			wall_cell,
			Vector2i(x,-1)
		)

		data.insert_static_cell(
			wall_cell,
			Vector2i(x,dungeon_height)
		)


	for y in range(dungeon_height):

		data.insert_static_cell(
			wall_cell,
			Vector2i(-1,y)
		)

		data.insert_static_cell(
			wall_cell,
			Vector2i(dungeon_width,y)
		)



func generate_dungeon(data: DungeonData):

	while true:

		update_entropies(data)

		collapse_lowest_entropy_cell(data)


		if data.grid.values().all(
			func(cell):
				return cell.entropy <= 1
		):
			break



	var connected = ConnectedCells.get_connected_cells(
		data.grid,
		data.cords_of_starting_cell
	)


	var temporary_wall = Cell.new()
	temporary_wall.resc = wall_resc
	temporary_wall.collapsed = true
	temporary_wall.entropy = 1


	for pos in data.grid.keys():

		if pos not in connected:

			data.insert_static_cell(
				temporary_wall,
				pos
			)



func update_entropies(data: DungeonData):

	for x in range(dungeon_width):

		for y in range(dungeon_height):

			var pos = Vector2i(x,y)

			var cell = data.get_cell(pos)

			cell.update_entropy(
				data.get_neighbors(pos),
				possible_cell_rescs,
				pos
			)



func collapse_lowest_entropy_cell(data: DungeonData):

	var lowest := INF
	var lowest_pos := Vector2i.ZERO


	for y in range(dungeon_height):

		for x in range(dungeon_width):

			var pos = Vector2i(x,y)
			var cell = data.get_cell(pos)


			if !cell.collapsed:

				if cell.entropy < lowest:

					lowest = cell.entropy
					lowest_pos = pos



	data.get_cell(lowest_pos).collapse()



func check_dungeon(data: DungeonData) -> bool:

	var room_count = data.count_non_wall_cells()


	if room_count <= min_room_count:
		return false


	if room_count >= max_room_count:
		return false



	var boss = ConnectedCells.find_cell_with_flag(
		data.grid,
		data.cords_of_starting_cell,
		Cell.Flag.BOSS
	)


	if boss == null:
		return false



	var distance = ConnectedCells.get_distance(
		data.grid,
		data.cords_of_starting_cell,
		boss
	)


	if distance < distance_to_boss:
		return false


	return true




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

				resources.append(
					load(path + "/" + folder + "/" + file)
				)


	return resources

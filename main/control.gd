extends Control

'''
var dungeon
var dungeon_width = 5
var dungeon_height = 5
var finished = false

func _ready():
	print("scene started")
	var start_time = Time.get_ticks_msec()
	
	dungeon = Dungeon.new(dungeon_width, dungeon_height, Vector2i(floor(dungeon_width/2), floor(dungeon_height/2)))
	
	var minimap = get_child(0).get_child(0)
	minimap.generateMinimap(dungeon_width, dungeon_height)
	minimap.updateMinimap(dungeon.grid)
	
	var wall_cell = Cell.new()
	wall_cell.resc = load("res://tiles/special/walls.tres")
	wall_cell.collapsed = true
	wall_cell.entropy = 1
	var starting_cell = Cell.new()
	starting_cell.resc = load('res://tiles/0/E0.tres')
	
	while finished == false:
		
		while true:
			dungeon.update_entropies()
			#dungeon.print_grid('entropy', false)
			dungeon.collapse_lowest_entropy_cell()
			minimap.updateMinimap(dungeon.grid)
			#await get_tree().create_timer(0.05).timeout
			
			if dungeon.grid.values().all(func(cell): return cell.entropy <= 1):
				finished = true
				break
	
		# removing cells that arent connected to the start room
		var connected = ConnectedCells.get_connected_cells(dungeon.grid, Vector2i(floor(dungeon_width/2), floor(dungeon_height/2)))

		for pos in dungeon.grid.keys():
			if pos not in connected:
				dungeon.insert_static_cell(wall_cell, pos)
		
		# adding boss room based on distance traversed from the start cell
		# changed due to problems with big rooms being assinged as boss rooms
		#var possible_boss_cords = ConnectedCells.get_cells_at_distance(dungeon.grid, dungeon.cords_of_starting_cell, 3)
		#dungeon.insert_static_cell(dungeon.boss_cell, possible_boss_cords.pick_random())
		
		var non_wall_count = dungeon.count_non_wall_cells()
		var min_room_count = 7
		var max_room_count = 15
		
		# if there are no boss cells that can be entered dungeon is regenerated
		if ConnectedCells.find_cell_with_flag(dungeon.grid, dungeon.cords_of_starting_cell, Cell.Flag.BOSS) and ConnectedCells.get_distance(dungeon.grid, dungeon.cords_of_starting_cell, ConnectedCells.find_cell_with_flag(dungeon.grid, dungeon.cords_of_starting_cell, Cell.Flag.BOSS)) >= 3 and non_wall_count > min_room_count and non_wall_count < max_room_count:
				finished = true
		else:
			# no boss reachable or size wrong
			dungeon.create_grid()
			minimap.updateMinimap(dungeon.grid)
			finished = false
			
		
		minimap.updateMinimap(dungeon.grid)
		#dungeon.print_grid('entropy', false)
		#dungeon.print_grid('rescs', false)
	
	var end_time = Time.get_ticks_msec()
	print("Took ", end_time - start_time, " ms")
'''
# multithreaded

var dungeon
var dungeon_width = 6
var dungeon_height = 6
var min_room_count = 7
var max_room_count = 15
var distance_to_boss = 3

var result_dungeon = null
var mutex := Mutex.new()
var threads: Array[Thread] = []


func _ready():
	print("scene started")

	var start_time = Time.get_ticks_msec()
	var thread_count = 4

	for i in range(thread_count):
		var thread = Thread.new()
		threads.append(thread)
		thread.start(generate_dungeon_thread)

	# wait until one thread finds a valid dungeon
	while result_dungeon == null:
		await get_tree().process_frame

	# stop other threads
	for thread in threads:
		thread.wait_to_finish()

	dungeon = result_dungeon

	var minimap = get_child(0).get_child(0)
	minimap.generateMinimap(dungeon_width, dungeon_height)
	minimap.updateMinimap(dungeon.grid)

	var end_time = Time.get_ticks_msec()
	print("Took ", end_time - start_time, " ms")



func generate_dungeon_thread():
	while true:
		# if another thread already finished
		mutex.lock()
		var already_found = result_dungeon != null
		mutex.unlock()

		if already_found:
			return

		var new_dungeon = Dungeon.new(
			dungeon_width,
			dungeon_height,
			Vector2i(
				floor(dungeon_width / 2),
				floor(dungeon_height / 2)
			)
		)

		generate_dungeon(new_dungeon)

		if check_dungeon(new_dungeon):
			mutex.lock()

			if result_dungeon == null:
				result_dungeon = new_dungeon

			mutex.unlock()

			return

func generate_dungeon(dungeon):
	var finished = false
	
	while !finished:
		while true:
			dungeon.update_entropies()
			dungeon.collapse_lowest_entropy_cell()

			if dungeon.grid.values().all(
				func(cell):
					return cell.entropy <= 1
			):
				break

		# remove disconnected cells

		var connected = ConnectedCells.get_connected_cells(
			dungeon.grid,
			dungeon.cords_of_starting_cell
		)

		var wall_cell = Cell.new()
		wall_cell.resc = load("res://tiles/special/walls.tres")
		wall_cell.collapsed = true
		wall_cell.entropy = 1

		for pos in dungeon.grid.keys():
			if pos not in connected:
				dungeon.insert_static_cell(
					wall_cell,
					pos
				)

		finished = true

func check_dungeon(dungeon) -> bool:
	var non_wall_count = dungeon.count_non_wall_cells()

	if non_wall_count <= min_room_count:
		return false

	if non_wall_count >= max_room_count:
		return false

	var boss = ConnectedCells.find_cell_with_flag(
		dungeon.grid,
		dungeon.cords_of_starting_cell,
		Cell.Flag.BOSS
	)

	if boss == null:
		return false

	var distance = ConnectedCells.get_distance(
		dungeon.grid,
		dungeon.cords_of_starting_cell,
		boss
	)

	if distance < distance_to_boss:
		return false

	return true

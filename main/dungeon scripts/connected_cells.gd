extends RefCounted
class_name ConnectedCells

# script that has many useful functions regarding space 

const OFFSETS = {
	"north": Vector2i(0, -1),
	"east": Vector2i(1, 0),
	"south": Vector2i(0, 1),
	"west": Vector2i(-1, 0)
}

const OPPOSITE = {
	"north": "south",
	"east": "west",
	"south": "north",
	"west": "east"
}

static func get_diamond_ring(grid: Dictionary, center: Vector2i, distance: int ) -> Array[Vector2i]:
	var result: Array[Vector2i] = []

	if distance == 0:
		if grid.has(center):
			result.append(center)
		return result

	for dx in range(-distance, distance + 1):
		var dy = distance - abs(dx)

		var p1 = center + Vector2i(dx, dy)
		if grid.has(p1):
			result.append(p1)

		if dy != 0:
			var p2 = center + Vector2i(dx, -dy)
			if grid.has(p2):
				result.append(p2)

	return result

static func get_connected_cells(grid: Dictionary, start: Vector2i) -> Array[Vector2i]:
	var visited := {}
	var queue: Array[Vector2i] = []

	queue.push_back(start)
	visited[start] = true

	while !queue.is_empty():
		var current = queue.pop_front()
		var cell = grid[current]

		# OPEN + DOOR directions are walkable
		var walkable: Array = cell.resc.open_directions().duplicate()
		walkable.append_array(cell.resc.door_directions())

		for dir in walkable:
			var neighbour_pos = current + OFFSETS[dir]

			if !grid.has(neighbour_pos):
				continue

			if visited.has(neighbour_pos):
				continue

			var neighbour = grid[neighbour_pos]
			
			if neighbour.resc != null:
				var neighbour_walkable: Array = neighbour.resc.open_directions().duplicate()
				neighbour_walkable.append_array(neighbour.resc.door_directions())

				# Both cells must agree that they're connected
				if OPPOSITE[dir] in neighbour_walkable:
					visited[neighbour_pos] = true
					queue.push_back(neighbour_pos)

	return visited.keys()

static func get_cells_in_distance(grid: Dictionary, start: Vector2i, max_distance: int) -> Array[Vector2i]:
	var visited := {}
	var queue: Array = []

	queue.push_back({
		"pos": start,
		"distance": 0
	})

	visited[start] = true

	while !queue.is_empty():
		var current = queue.pop_front()
		var pos: Vector2i = current.pos
		var distance: int = current.distance

		if distance >= max_distance:
			continue

		var cell = grid[pos]

		var walkable: Array = cell.resc.open_directions().duplicate()
		walkable.append_array(cell.resc.door_directions())

		for dir in walkable:
			var neighbour_pos = pos + OFFSETS[dir]

			if !grid.has(neighbour_pos):
				continue

			if visited.has(neighbour_pos):
				continue

			var neighbour = grid[neighbour_pos]

			if neighbour.resc != null:
				var neighbour_walkable: Array = neighbour.resc.open_directions().duplicate()
				neighbour_walkable.append_array(neighbour.resc.door_directions())

				if OPPOSITE[dir] in neighbour_walkable:
					visited[neighbour_pos] = true

					queue.push_back({
						"pos": neighbour_pos,
						"distance": distance + 1
					})

	return visited.keys()

static func get_cells_at_distance(grid: Dictionary, start: Vector2i, target_distance: int) -> Array[Vector2i]:
	var current_frontier: Array[Vector2i] = [start]
	var visited := {start: true}

	if target_distance == 0:
		return [start]

	var last_valid_frontier: Array[Vector2i] = [start]

	for distance in range(1, target_distance + 1):
		var next_frontier: Array[Vector2i] = []

		for pos in current_frontier:
			var cell = grid[pos]

			var walkable: Array = cell.resc.open_directions().duplicate()
			walkable.append_array(cell.resc.door_directions())

			for dir in walkable:
				var neighbour_pos = pos + OFFSETS[dir]

				# outside grid
				if !grid.has(neighbour_pos):
					continue

				# already visited
				if visited.has(neighbour_pos):
					continue

				var neighbour = grid[neighbour_pos]

				if neighbour.resc != null:
					var neighbour_walkable: Array = neighbour.resc.open_directions().duplicate()
					neighbour_walkable.append_array(neighbour.resc.door_directions())

					# both rooms must connect
					if OPPOSITE[dir] in neighbour_walkable:
						visited[neighbour_pos] = true
						next_frontier.append(neighbour_pos)

		# if we found a new ring, remember it
		if !next_frontier.is_empty():
			last_valid_frontier = next_frontier

		current_frontier = next_frontier

		# no more expansion possible
		if current_frontier.is_empty():
			break

	return last_valid_frontier

static func find_cell_with_flag(grid: Dictionary, start: Vector2i, flag_name: DungeonCell.Flag):
	var visited := {}
	var queue: Array[Vector2i] = []

	queue.push_back(start)
	visited[start] = true

	while !queue.is_empty():
		var current = queue.pop_front()
		var cell = grid[current]

		# found it
		if cell.flag == flag_name:
			return current

		var walkable: Array = cell.resc.open_directions().duplicate()
		walkable.append_array(cell.resc.door_directions())

		for dir in walkable:
			var neighbour_pos = current + OFFSETS[dir]

			if !grid.has(neighbour_pos):
				continue

			if visited.has(neighbour_pos):
				continue

			var neighbour = grid[neighbour_pos]

			if neighbour.resc != null:
				var neighbour_walkable: Array = neighbour.resc.open_directions().duplicate()
				neighbour_walkable.append_array(neighbour.resc.door_directions())

				if OPPOSITE[dir] in neighbour_walkable:
					visited[neighbour_pos] = true
					queue.push_back(neighbour_pos)

	# nothing found
	return null

static func get_distance(grid: Dictionary, start: Vector2i, target: Vector2i) -> int:
	if start == target:
		return 0

	var visited := {}
	var queue: Array = []

	queue.push_back({
		"pos": start,
		"distance": 0
	})

	visited[start] = true

	while !queue.is_empty():
		var current = queue.pop_front()
		var pos: Vector2i = current.pos
		var distance: int = current.distance

		var cell = grid[pos]

		var walkable: Array = cell.resc.open_directions().duplicate()
		walkable.append_array(cell.resc.door_directions())

		for dir in walkable:
			var neighbour_pos = pos + OFFSETS[dir]

			if !grid.has(neighbour_pos):
				continue

			if visited.has(neighbour_pos):
				continue

			var neighbour = grid[neighbour_pos]

			if neighbour.resc == null:
				continue

			var neighbour_walkable: Array = neighbour.resc.open_directions().duplicate()
			neighbour_walkable.append_array(neighbour.resc.door_directions())

			if OPPOSITE[dir] in neighbour_walkable:
				if neighbour_pos == target:
					return distance + 1

				visited[neighbour_pos] = true
				queue.push_back({
					"pos": neighbour_pos,
					"distance": distance + 1
				})

	return -1

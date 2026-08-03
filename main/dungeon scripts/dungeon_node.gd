extends Node3D
class_name DungeonNode

var room_scene = load("res://DungeonRoom.tscn")
var node_grid: Dictionary = {}


func generate(grid):
	print(grid)
	var grid_size = int(sqrt(grid.size()))
	
	for pos in grid:
		# remove border
		if pos.x == -1 or pos.y == -1 or pos.x == grid_size - 2 or pos.y == grid_size - 2:
			continue

		var room = room_scene.instantiate()

		node_grid[pos] = room
		add_child(room)

		room.position = Vector3(pos.x * 8, 0, pos.y * 8)
		
		if room.configure_room(grid[pos]):
			node_grid[pos] = room
		else:
			node_grid[pos] = null
		
		if pos == Vector2i(floor(sqrt(grid.size())/2)-1, floor(sqrt(grid.size())/2)-1):
			get_parent().get_node("Camera3D").position = Vector3(
				pos.x * 8,
				16,
				pos.y * 8
			)

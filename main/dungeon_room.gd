extends Node3D

var direction_nodes = {
	"north": {
		"wall": "wall1",
		"door": "door1"
	},
	"east": {
		"wall": "wall2",
		"door": "door2"
	},
	"south": {
		"wall": "wall3",
		"door": "door3"
	},
	"west": {
		"wall": "wall4",
		"door": "door4"
	}
}


func configure_room(cell):
	# start with default state
	for direction in direction_nodes:
		var wall = get_node(direction_nodes[direction]["wall"])
		var door = get_node(direction_nodes[direction]["door"])

		wall.visible = true
		door.visible = false


	# apply cell rules
	var doors = cell.resc.door_directions()
	var walls = cell.resc.wall_directions()
	var opens = cell.resc.open_directions()


	for direction in doors:
		var wall = get_node(direction_nodes[direction]["wall"])
		var door = get_node(direction_nodes[direction]["door"])

		wall.visible = false
		door.visible = true


	for direction in opens:
		# don't overwrite doors
		if direction in doors:
			continue

		var wall = get_node(direction_nodes[direction]["wall"])
		wall.visible = false 
		
	# normal setup...
	if walls.size() == 4:
		queue_free()
		return false
	else:
		return true

extends Control

@onready var grid_container = get_child(0)
var minimap_cell_scene = preload("res://MinimapCell.tscn")
var wall_resc = load('res://tiles/special/walls.tres')

var minimap_cells = {}
var width = 0 
var height = 0
var cell_grid

func generateMinimap(Width, Height):
	width = Width
	height = Height
	grid_container.columns = width
	
	for y in range(height):
		for x in range(width):

			var minimap_cell = minimap_cell_scene.instantiate()
			minimap_cell.grid_position = Vector2i(x, y)
			minimap_cell.clicked.connect(_on_cell_clicked)
			grid_container.add_child(minimap_cell)
			minimap_cells[Vector2i(x, y)] = minimap_cell


func updateMinimap(grid):
	cell_grid = grid
	var dir_to_index = {
		"north": 0,
		"east": 1,
		"south": 2,
		"west": 3
	}
	
	for y in range(height):
		for x in range(width):
			var minimap_cell = minimap_cells[Vector2i(x, y)]
			var cell = grid[Vector2i(x, y)]
			minimap_cell.get_child(1).add_theme_color_override("font_color", Color.BLACK)
				
			if Cell.Flag.find_key(cell.flag) != 'NONE':
				minimap_cell.get_child(1).add_theme_color_override("font_color", Color.RED)
			minimap_cell.get_child(1).text = Cell.Flag.find_key(cell.flag)
			
			
			
			if cell.resc != null:
				if cell.resc == wall_resc:
					minimap_cell.get_child(0).get_child(1).visible = true
					continue
					
				var walls = cell.resc.wall_directions()
				var doors = cell.resc.door_directions()
				
				for i in range(4):
					minimap_cell.get_child(0).get_node("wall%d" % i).visible = false
					minimap_cell.get_child(0).get_node("door%d" % i).visible = false
				
				for dir in walls:
					minimap_cell.get_child(0).get_node("wall%d" % dir_to_index[dir]).visible = true
				
				for dir in doors:
					minimap_cell.get_child(0).get_node("door%d" % dir_to_index[dir]).visible = true
				
				minimap_cell.get_child(0).get_child(1).visible = false
				

func _on_cell_clicked(pos: Vector2i):
	print("Clicked minimap cell:", pos)

	#var dungeon_cell = cell_grid[pos].resc.get_path()
	print(cell_grid[pos].debug_log)
	var file = FileAccess.open("res://debug.txt", FileAccess.WRITE)
	file.store_string(cell_grid[pos].debug_log)
	file.close()

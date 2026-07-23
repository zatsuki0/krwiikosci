@tool
extends EditorScript

const TILE_FOLDER = "res://tiles/0/"
const OUTPUT_FOLDER = "res://tiles/1W/"

enum Edge {
	NORTH,
	EAST,
	SOUTH,
	WEST
}

var edge_letters = {
	Edge.NORTH: "N",
	Edge.EAST: "E",
	Edge.SOUTH: "S",
	Edge.WEST: "W"
}

# Change this list to decide which openings you want generated
# Example:
# ["N"]
# ["N", "E"]
# ["S", "W"]
# ["N", "E", "S", "W"]

var open_edges = [
	Edge.WEST
]


func _run():

	DirAccess.make_dir_recursive_absolute(OUTPUT_FOLDER)

	var tiles = load_existing_tiles()

	for tile in tiles:
		generate_from_tile(tile)


	print("Generation finished")


func load_existing_tiles() -> Array:

	var result = []

	var dir = DirAccess.open(TILE_FOLDER)

	if dir == null:
		return result


	for file in dir.get_files():

		if file.ends_with(".tres"):

			var path = TILE_FOLDER + file

			var tile = load(path)

			if tile is TileType:
				result.append(tile)


	return result



func generate_from_tile(original: TileType):

	# Check if any requested opening is blocked by a door
	for edge in open_edges:

		if get_edge(original, edge) == TileType.EdgeType.DOOR:

			print(
				"Skipping ",
				original.tile_name,
				" because ",
				edge_letters[edge],
				" has a door"
			)

			return


	# Create copy
	var new_tile = original.duplicate()


	# Apply openings
	for edge in open_edges:

		set_edge(
			new_tile,
			edge,
			TileType.EdgeType.OPEN
		)


	var filename = generate_name(new_tile)

	# Set the resource's name
	new_tile.tile_name = filename

	var save_path = OUTPUT_FOLDER + filename + ".tres"


	ResourceSaver.save(
		new_tile,
		save_path
	)

	print("Created ", save_path)



func get_edge(tile: TileType, edge:int):

	match edge:

		Edge.NORTH:
			return tile.north

		Edge.EAST:
			return tile.east

		Edge.SOUTH:
			return tile.south

		Edge.WEST:
			return tile.west



func set_edge(tile:TileType, edge:int, value):

	match edge:

		Edge.NORTH:
			tile.north = value

		Edge.EAST:
			tile.east = value

		Edge.SOUTH:
			tile.south = value

		Edge.WEST:
			tile.west = value



func generate_name(tile:TileType) -> String:

	var doors = ""
	var open = ""

	var edge_values = [
		Edge.NORTH,
		Edge.EAST,
		Edge.SOUTH,
		Edge.WEST
	]


	for edge in edge_values:

		if get_edge(tile, edge) == TileType.EdgeType.DOOR:

			doors += edge_letters[edge]


		if get_edge(tile, edge) == TileType.EdgeType.OPEN:

			open += edge_letters[edge]


	var open_count = open.length()


	return doors + str(open_count) + open

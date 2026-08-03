extends Node

#var player = Player.new()
var dungeon
var minimap_scene = load("res://Minimap.tscn")
var dungeon_scene = preload("res://Dungeon.tscn")
#var dungeon_map
@onready var minimap = get_tree().current_scene.get_child(0).get_node("Minimap")

var player_scene = preload("res://main scenes/player.tscn")
var player

func _ready():
	print("GameManager loaded")
	
	#generate dungeon and dungeon scene
	#dungeon = Dungeon.new(5,5)
	dungeon = dungeon_scene.instantiate()
	get_tree().current_scene.add_child(dungeon)
	dungeon.position = Vector3.ZERO
	
	dungeon.setup(5, 5)
	minimap.generateMinimap(5, 5)
	await dungeon.generate()
	dungeon.generate_node()
	minimap.updateMinimap(dungeon.data.grid)
	
	#create and add a player
	player = player_scene.instantiate()
	get_tree().current_scene.get_node("Dungeon").add_child(player)
	player.position = Vector3i(2*8, 1, 2*8)
	
	player.setup("name", "human")
	player.update_stats()
	
	print("head name: ", player.get_limb(LimbData.LimbType.HEAD).data.display_name)
	print("torso name: ", player.get_limb(LimbData.LimbType.TORSO).data.display_name)
	print("arm name: ", player.get_limb(LimbData.LimbType.ARM).data.display_name)
	print("leg name: ", player.get_limb(LimbData.LimbType.LEG).data.display_name)
	
func enter_battle(enemy):
	SceneManager.enter_battle(enemy)

func enter_dungeon():
	SceneManager.enter_dungeon()

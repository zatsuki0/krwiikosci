extends Node

#var player = Player.new()
var dungeon: Dungeon
var minimap_scene = load("res://Minimap.tscn")
@onready var minimap = get_tree().current_scene.get_child(0).get_node("Minimap")

func _ready():
	print("GameManager loaded")
	
	dungeon = Dungeon.new(5,5)
	
	minimap.generateMinimap(5, 5)
	
	await dungeon.generate()
	
	print(get_tree().current_scene.get_child(0).get_children())
	
	minimap.updateMinimap(dungeon.data.grid)
	
	
func enter_battle(enemy):
	SceneManager.enter_battle(enemy)

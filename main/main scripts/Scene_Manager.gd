extends Node

enum GameState {
	WORLD,
	BATTLE,
	SHOP,
	MENU
}

var current_state = GameState.WORLD

func _ready():
	print("SceneManager loaded")


func enter_battle(enemy):
	current_state = GameState.BATTLE

	#change_world("res://Scenes/Battle/Battle.tscn")
	#change_ui("res://UI/BattleUI.tscn")
	
func leave_battle():
	current_state = GameState.WORLD

	#change_world(previous_world)
	#change_ui("res://UI/WorldUI.tscn")

func enter_dungeon():
	current_state = GameState.WORLD

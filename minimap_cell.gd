extends Control
class_name MinimapCell

signal clicked

var grid_position: Vector2i

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clicked.emit(grid_position)
			

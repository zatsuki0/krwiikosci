extends Control

@export var left_button_count: int = 2
@export var right_button_count: int = 2

var button_group := ButtonGroup.new()

@onready var top_button: CheckButton = $PanelContainer/MarginContainer/VBoxContainer3/CenterContainer/head
@onready var second_button: CheckButton = $PanelContainer/MarginContainer/VBoxContainer3/CenterContainer2/torso
@onready var bottom_left_button: CheckButton = $PanelContainer/MarginContainer/VBoxContainer3/HBoxContainer/leg1L
@onready var bottom_right_button: CheckButton = $PanelContainer/MarginContainer/VBoxContainer3/HBoxContainer/leg1R

@onready var left_column: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer3/HBoxContainer2/LeftColumn
@onready var right_column: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer3/HBoxContainer2/RightColumn

@onready var add_left_button_control: Button = $GridContainer/AddLeftButton
@onready var remove_left_button_control: Button = $GridContainer/RemoveLeftButton
@onready var add_right_button_control: Button = $GridContainer/AddRightButton
@onready var remove_right_button_control: Button = $GridContainer/RemoveRightButton

func _ready() -> void:
	button_group.allow_unpress = true

	add_left_buttons(left_button_count)
	add_right_buttons(right_button_count)
	
	add_left_button_control.pressed.connect(add_left_button)
	remove_left_button_control.pressed.connect(remove_left_button)
	add_right_button_control.pressed.connect(add_right_button)
	remove_right_button_control.pressed.connect(remove_right_button)

#the rest of the buttons i didn't make generated, so it's this. 
	top_button.button_group = button_group
	second_button.button_group = button_group
	bottom_left_button.button_group = button_group
	bottom_right_button.button_group = button_group
#head, torso, both legs.  Should've made legs be generated, but i didn't and im running out of time
	
func add_left_buttons(amount: int) -> void:
	for i in range(amount):
		add_left_button()


func add_right_buttons(amount: int) -> void:
	for i in range(amount):
		add_right_button()


func add_left_button() -> void:
	var button := CheckButton.new()
	button.text = "Larm %d" % (left_column.get_child_count() + 1)
	button.button_group = button_group
	left_column.add_child(button)


func add_right_button() -> void:
	var button := CheckButton.new()
	button.text = "Rarm %d" % (right_column.get_child_count() + 1)
	button.button_group = button_group
	right_column.add_child(button)


func remove_left_button() -> void:
	if left_column.get_child_count() > 0:
		var button = left_column.get_child(left_column.get_child_count() - 1)
		button.queue_free()


func remove_right_button() -> void:
	if right_column.get_child_count() > 0:
		var button = right_column.get_child(right_column.get_child_count() - 1)
		button.queue_free()

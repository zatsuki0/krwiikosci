extends CharacterBody3D
class_name PlayerCharacter

@export var speed := 15

func _physics_process(delta):
	var input = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	var direction = Vector3(input.x, 0, input.y)

	if direction.length() > 0:
		direction = direction.normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	move_and_slide()

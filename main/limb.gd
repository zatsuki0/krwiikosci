extends Node
class_name Limb

var data:LimbData
var node:LimbNode

func setup(limb_data: LimbData, limb_node: LimbNode):
	data = limb_data
	node = limb_node

	data.changed.connect(update)
	

func add_rune(rune: Rune):
	data.runes.append(rune)
	data.emit_changed()


func add_mutation(mutation: String):
	data.mutations.append(mutation)
	data.emit_changed()


func update():
	if data.missing:
		node.destroy()

	# node.refresh()
	

func take_damage(amount: float):
	if data.missing:
		return

	data.health -= amount
	data.health = max(data.health, 0)

	if data.health <= 0:
		break_limb()

	data.emit_changed()


func attack(enemy_limb: Limb):
	return


func heal(amount: float):
	if data.missing:
		return

	data.health += amount
	data.health = min(
		data.health,
		data.max_health
	)

	data.emit_changed()

func break_limb():
	data.missing = true
	data.health = 0

	data.emit_changed()

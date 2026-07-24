extends Node
class_name Player

var data: PlayerData
var character: PlayerCharacter
var limbs: Array[Limb] = []


func _init(name: String, background: String):
	ready


func _ready():
	if data == null:
		data = PlayerData.new()

	create_default_body()


func create_default_body():
	add_limb(LimbData.LimbType.HEAD)
	add_limb(LimbData.LimbType.TORSO)
	add_limb(LimbData.LimbType.ARM)
	add_limb(LimbData.LimbType.ARM)
	add_limb(LimbData.LimbType.LEG)
	add_limb(LimbData.LimbType.LEG)


func add_limb(type: LimbData.LimbType, node: LimbNode = LimbNode.new()):
	var limb := Limb.new()
	var limb_data := LimbData.new()
	var limb_node := LimbNode.new()
	limb_data.limb_type = type

	limb.setup(limb_data, limb_node)
	limb.changed.connect(update_limb)
	
	limbs.append(limb)


func update_limb(limb:Limb):
	
	# Update things affected by limb changes
	'''
	match limb.data.limb_type:
		LimbData.LimbType.LEFT_ARM:
			update_attack()
		LimbData.LimbType.RIGHT_ARM:
			update_attack()
		LimbData.LimbType.LEFT_LEG:
			update_movement()
		LimbData.LimbType.RIGHT_LEG:
			update_movement()
	'''

	update_health()



func update_health():

	# Recalculate total health for body
	var total := 0.0

	for limb in limbs:
		total += limb.data.health

	data.health = total


# placeholder for now
func update_damage():

	var damage := 0.0
	for limb in limbs:
		
		if limb.data.limb_type == LimbData.LimbType.ARM:
			damage += limb.get_attack_power()


func update_movement():

	var agility := 100.0

	for limb in limbs:
		if limb.data.limb_type == LimbData.LimbType.LEG:
			agility *= limb.get_movement_modifier()

	data.agility = agility



func get_limb(type:LimbData.LimbType):

	for limb in limbs:
		if limb.data.limb_type == type:
			return limb

	return null

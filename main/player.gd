extends Node
class_name Player

var data: PlayerData
var character: PlayerCharacter
var limbs: Array[Limb] = []

func _init():
	ready

func setup(name: String, background: String):
	data.name = name
	data.background = background
	
	if background == "human":
		var head = Limb.new()
		head.data = load("res://limbs/heads/human_head.tres").duplicate()
		head.node = LimbNode.new()
	
		replace_limb(LimbData.LimbType.HEAD, 0, head)
		
		var torso = Limb.new()
		torso.data = load("res://limbs/torsos/human_torso.tres").duplicate()
		torso.node = LimbNode.new()
	
		replace_limb(LimbData.LimbType.TORSO, 0, torso)
		
		var arm0 = Limb.new()
		arm0.data = load("res://limbs/arms/human_arm.tres").duplicate()
		arm0.node = LimbNode.new()
	
		replace_limb(LimbData.LimbType.ARM, 0, arm0)
		
		var arm1 = Limb.new()
		arm1.data = load("res://limbs/arms/human_arm.tres").duplicate()
		arm1.node = LimbNode.new()
	
		replace_limb(LimbData.LimbType.ARM, 1, arm1)
		
		var leg0 = Limb.new()
		leg0.data = load("res://limbs/legs/human_leg.tres").duplicate()
		leg0.node = LimbNode.new()
	
		replace_limb(LimbData.LimbType.LEG, 0, leg0)
		
		var leg1 = Limb.new()
		leg1.data = load("res://limbs/legs/human_leg.tres").duplicate()
		leg1.node = LimbNode.new()
	
		replace_limb(LimbData.LimbType.LEG, 1, leg1)

func _ready():
	if data == null:
		data = PlayerData.new()
	
	character = $PlayerCharacter
	
	create_default_body()


func create_default_body():
	add_limb(LimbData.LimbType.HEAD)
	add_limb(LimbData.LimbType.TORSO)
	add_limb(LimbData.LimbType.ARM)
	add_limb(LimbData.LimbType.ARM)
	add_limb(LimbData.LimbType.LEG)
	add_limb(LimbData.LimbType.LEG)


func add_limb(type: LimbData.LimbType, limb: Limb = null):
	var new_limb
	if limb == null:
		new_limb = Limb.new()
		var limb_data := LimbData.new()
		var limb_node := LimbNode.new()
		limb_data.limb_type = type
		limb_data.display_name = "template"

		new_limb.setup(limb_data, limb_node)
		new_limb.changed.connect(update_limb)
	else:
		new_limb = limb
	
	limbs.append(new_limb)

func remove_limb(type: LimbData.LimbType):
	for limb in limbs:
		if limb.get_type() == type:
			limbs.erase(limb)

func get_limb(type:LimbData.LimbType):
	for limb in limbs:
		if limb.data.limb_type == type:
			return limb

	return null

func replace_limb(type: LimbData.LimbType, instance: int, new_limb: Limb):
	var current_instance := 0

	for i in range(limbs.size()):
		if limbs[i].data.limb_type == type:
			if current_instance == instance:
				limbs[i] = new_limb
				return

			current_instance += 1


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

func update_stats():
	var vit = 0
	var vig = 0 
	var res = 0 
	var comp = 0
	var fer = 0
	var susc = 0
	
	for limb in limbs:
		vit += limb.data.get_stat(Stats.Type.VITALITY)
		vig += limb.data.get_stat(Stats.Type.VIGOUR)
		res += limb.data.get_stat(Stats.Type.RESILIENCE)
		comp += limb.data.get_stat(Stats.Type.COMPREHENSION)
		fer += limb.data.get_stat(Stats.Type.FEROCITY)
		susc += limb.data.get_stat(Stats.Type.SUSCEPTIBILITY)
	
	data.base_stats[Stats.Type.VITALITY] = vit
	data.base_stats[Stats.Type.VIGOUR] = vig
	data.base_stats[Stats.Type.RESILIENCE] = res
	data.base_stats[Stats.Type.COMPREHENSION] = comp
	data.base_stats[Stats.Type.FEROCITY] = fer
	data.base_stats[Stats.Type.SUSCEPTIBILITY] = susc

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

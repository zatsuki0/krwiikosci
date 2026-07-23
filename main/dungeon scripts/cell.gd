extends Node
class_name Cell

var collapsed = false
var collapsable_resources: Array[Resource] = []
var entropy = 300
var resc = null
var debug_log: String = ""
var position: Vector2i

enum Flag {
	NONE,
	BORDER,
	START,
	BOSS,
	TREASURE,
	SHOP,
	EXIT,
	SAFE,
	SECRET
}

var flag: Flag = Flag.NONE


func update_entropy(neighbors: Dictionary, all_possible_resources: Array[Resource], cords: Vector2i):
	collapsable_resources.clear()
	
	# check if isnt already collapsed
	if collapsed:
		entropy = 1
		if global.debug: debug_log += 'cell already collapsed \n'
		return
	else:
		var restrictions = {"DOOR": [], "OPEN": [], "WALL": []}

		var north = neighbors["north"]
		var south = neighbors["south"]
		var west = neighbors["west"]
		var east = neighbors["east"]
		
		var encased = false
		#check for doors and opens
		if global.debug: debug_log += 'checking cell {cell_pos} \n'.format({"cell_pos": cords})
		if global.debug: debug_log += 'checking north \n'
		if north.resc !=null:
			if north.resc.south == 2:
				restrictions["DOOR"].append('north')
				if global.debug: debug_log += 'required DOOR on north \n'
			if north.resc.south == 1:
				restrictions["OPEN"].append('north')
				if global.debug: debug_log += 'required OPEN on north \n'
			if north.resc.south == 0:
				restrictions["WALL"].append('north')
				if global.debug: debug_log += 'required WALL on north \n'
				
		if global.debug: debug_log += 'checking south \n'
		if south.resc !=null:
			if south.resc.north == 2:
				restrictions["DOOR"].append('south')
				if global.debug: debug_log += 'required DOOR on south \n'
			if south.resc.north == 1:
				restrictions["OPEN"].append('south')
				if global.debug: debug_log += 'required OPEN on south \n'
			if south.resc.north == 0:
				restrictions["WALL"].append('south')
				if global.debug: debug_log += 'required WALL on south \n'
		
		if global.debug: debug_log += 'checking east \n'
		if east.resc !=null:
			if east.resc.west == 2:
				restrictions["DOOR"].append('east')
				if global.debug: debug_log += 'required DOOR on east \n'
			if east.resc.west == 1:
				restrictions["OPEN"].append('east')
				if global.debug: debug_log += 'required OPEN on east \n'
			if east.resc.west == 0:
				restrictions["WALL"].append('east')
				if global.debug: debug_log += 'required WALL on east \n'
			
		if global.debug: debug_log += 'checking west \n'
		if west.resc !=null:
			if west.resc.east == 2:
				restrictions["DOOR"].append('west')
				if global.debug: debug_log += 'required DOOR on west \n'
			if west.resc.east == 1:
				restrictions["OPEN"].append('west')
				if global.debug: debug_log += 'required OPEN on west \n'
			if west.resc.east == 0:
				restrictions["WALL"].append('west')
				if global.debug: debug_log += 'required WALL on west \n'
		

		if global.debug: debug_log += 'current restrictions: {rest} \n'.format({"rest": restrictions})
		
		if global.debug: debug_log += 'checking possible cells based on requirements \n'
		for resource in all_possible_resources:
			if global.debug:  debug_log += 'checking cell: {resc}'.format({"resc": resource}) 
			
			if restrictions["DOOR"].all(func(door): return door in resource.door_directions()) and encased == false:
				if global.debugD:  
					debug_log += '[✓] DOOR restrictions: {restrictions_door} (resc doors: {door_resc}) \n'.format({"door_resc": resource.door_directions(), "restrictions_door": restrictions["DOOR"]})
				
				if restrictions["OPEN"].all(func(open): return open in resource.open_directions()):
					if global.debugD:  
						debug_log += '[✓] OPEN restrictions: {restrictions_open} (resc open: {open_resc}) \n'.format({"open_resc": resource.open_directions(), "restrictions_open": restrictions["OPEN"]})
						
					if restrictions["WALL"].all(func(wall): return wall in resource.wall_directions()):
						if global.debugD:  
							debug_log += '[✓] WALL restrictions: {restrictions_wall} (resc wall: {wall_resc}) \n'.format({"wall_resc": resource.wall_directions(), "restrictions_wall": restrictions["WALL"]})

						collapsable_resources.append(resource)
					else: if global.debugD: debug_log += '[✗] WALL restrictions: {restrictions_wall} (resc wall: {wall_resc}) \n'.format({"wall_resc": resource.wall_directions(), "restrictions_wall": restrictions["WALL"]})
				else: if global.debugD:  debug_log += '[✗] OPEN restrictions: {restrictions_open} (resc open: {open_resc}) \n'.format({"open_resc": resource.open_directions(), "restrictions_open": restrictions["OPEN"]})
			else: if global.debugD:  debug_log += '[✗] DOOR restrictions: {restrictions_door} (resc doors: {door_resc}) \n'.format({"door_resc": resource.door_directions(), "restrictions_door": restrictions["DOOR"]})

			
		entropy = len(collapsable_resources)
			
		
	
	if global.debug:
			debug_log += 'entropy: {entropy} \n'.format({"entropy": entropy})
			debug_log += 'collapsable resources: {rescs} \n'.format({"rescs": collapsable_resources})
			debug_log += '-------------------- \n'

func collapse():
	resc = weighted_random(collapsable_resources)
	if resc == null:
		if global.debug: debug_log += 'collapsable resources: {rescs} \n'.format({"rescs": collapsable_resources})
		if global.debug: debug_log += 'found no valid resources for collapse \n' 
		resc = load("res://tiles/special/walls.tres")
		
	collapsed = true
	entropy = 1
	if global.debug: debug_log += 'cell collapsed with rescource: {resc} \n'.format({"resc": resc}) 
	

# misc functions
func weighted_random(options: Array):
	if options.size() == 1:
		return options[0]
		
	var total_weight = 0
	
	for item in options:
		total_weight += item.weight
	
	var random_value = randf_range(0.01, total_weight)
	
	var current_weight = 0
	
	for item in options:
		current_weight += item.weight
		
		if random_value <= current_weight:
			return item


func is_fully_walled():
	return resc.wall_directions().size() == 4

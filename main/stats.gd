class_name Stats

enum Type {
	VITALITY,
	VIGOUR,
	RESILIENCE,
	COMPREHENSION,
	FEROCITY,
	SUSCEPTIBILITY
}

const NAME := {
	Type.VITALITY: "Vitality",
	Type.VIGOUR: "Vigour",
	Type.RESILIENCE: "Resilience",
	Type.COMPREHENSION: "Comprehension",
	Type.FEROCITY: "Ferocity",
	Type.SUSCEPTIBILITY: "Susceptibility"
}

static func get_name(stat: Type) -> String:
	return NAME[stat]



const DESCRIPTION := {
	Type.VITALITY: "Determines maximum health.",
	Type.VIGOUR: "Determines stamina? and regeneration.",
	Type.RESILIENCE: "Determines resistance to physical trauma.",
	Type.COMPREHENSION: "Determines understanding of book knowledge.",
	Type.FEROCITY: "Determines melee damage and brutality.",
	Type.SUSCEPTIBILITY: "Determines effectiveness of runes."
}

static func get_description(stat: Type) -> String:
	return DESCRIPTION[stat]



'''
const ICON := {
	Type.VITALITY: preload("res://ui/icons/vitality.png"),
	
}


static func get_icon(stat: Type) -> String:
	return ICON[stat]
'''

extends Node


func execute(unit: InstancedUnit, effect, ally_army, enemy_army):
	var effect_type: String = effect[0]
	
	if effect_type.to_lower() == "buff":
		buff(unit, effect, ally_army, enemy_army)


func buff(unit: InstancedUnit, effect, ally_army, enemy_army):
	var attr_effect = effect[1]
	var target_team: String = effect[2][0] # Ally | Enemy
	var target_direction: String = effect[2][1]
	
	if target_team.to_lower() == "ally":
		var target_pos = get_relative_ally_position(unit.position, target_direction)
		
		if target_pos != -1 and ally_army.units[target_pos] != null:
			var target_unit: InstancedUnit = ally_army.units[target_pos]
			modify_attribute(target_unit, attr_effect)


func get_relative_ally_position(base_pos: int, direction: String) -> int:
	if direction.to_lower() == "front":
		if base_pos % 2 == 1: # Unit is at the back
			return base_pos - 1
		return -1
	elif direction.to_lower() == "self":
		return base_pos
	return -1


func modify_attribute(unit: InstancedUnit, attribute_effect):
	var attr: String = attribute_effect[0].to_lower()
	var modifier: String = attribute_effect[1].to_lower()
	var value: int = attribute_effect[2]
	
	if attr == "attack":
		if modifier == "sum":
			unit.add_bonus_attack(value)
		elif modifier == "mult":
			unit.add_bonus_attack(int(unit.curr_attack * value))
	elif attr == "health":
		if modifier == "sum":
			unit.add_bonus_health(value)
		elif modifier == "mult":
			unit.add_bonus_health(int(unit.curr_health * value))

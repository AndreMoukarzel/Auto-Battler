extends Node



func execute(unit, effect, ally_army, enemy_army):
	var effect_type: String = effect[0]
	
	if effect_type.to_lower() == "buff":
		buff(unit, effect, ally_army, enemy_army)
	elif effect_type.to_lower() == "damage":
		damage(unit, effect, ally_army, enemy_army)
	else:
		push_warning("[EffectHandler] UNKOWN EFFECT TYPE " + effect_type)


func buff(unit, effect, ally_army, enemy_army):
	var attr_effect = effect[1]
	var target_team: String = effect[2][0] # Ally | Enemy
	var target_direction: String = effect[2][1]
	
	if target_team.to_lower() == "ally":
		var target_pos = get_relative_ally_position(unit.unit_position, target_direction)
		
		if target_pos != -1 and ally_army.units[target_pos] != null:
			var target_unit = ally_army.units[target_pos]
			modify_attribute(target_unit, attr_effect)
	else:
		push_warning("[EffectHandler][Buff] UNKOWN TARGET ARMY TYPE " + target_team)


func damage(unit, effect, ally_army, enemy_army):
	var damage_value: int = effect[1]
	var target_team: String = effect[2][0] # Ally | Enemy
	var target_direction: String = effect[2][1]
	var frequency: int = effect[3]
	
	for i in range(frequency):
		if target_team.to_lower() == "enemy":
			var target_pos = get_relative_enemy_position(unit.unit_position, target_direction, enemy_army)
			
			if target_pos != -1 and ally_army.units[target_pos] != null:
				var target_unit = enemy_army.units[target_pos]
				target_unit.damage(damage_value)
		else:
			push_warning("[EffectHandler][Damage] UNKOWN TARGET ARMY TYPE " + target_team)
		await get_tree().create_timer(.5).timeout 


func get_relative_ally_position(base_pos: int, direction: String) -> int:
	if direction.to_lower() == "front":
		if base_pos % 2 == 1: # Unit is at the back
			return base_pos - 1
	elif direction.to_lower() == "back":
		if base_pos % 2 == 0: # Unit is at the front
			return base_pos + 1 
	elif direction.to_lower() == "self":
		return base_pos
	else:
		push_warning("[EffectHandler] UNKOWN ALLY POSITION " + direction)
	return -1


func get_relative_enemy_position(base_pos: int, direction: String, enemy_army: Node3D) -> int:
	if direction.to_lower() == "front":
		var unit_column: int = floor(base_pos / 2)
		# If there is an unit at the frontal space, return its position
		# Else, checks for unit at the back
		if enemy_army.units[unit_column * 2] != null:
			return unit_column * 2
		if enemy_army.units[(unit_column * 2) + 1] != null:
			return (unit_column * 2) + 1
		return -1
	else:
		push_warning("[EffectHandler] UNKOWN ALLY POSITION " + direction)
	return -1


func modify_attribute(unit, attribute_effect):
	var attr: String = attribute_effect[0].to_lower()
	var modifier: String = attribute_effect[1].to_lower()
	var value: int = attribute_effect[2]
	
	if attr == "attack":
		if modifier == "sum":
			unit.add_bonus_attack(value)
		elif modifier == "mult":
			unit.add_bonus_attack(int(unit.curr_attack * (value - 1.0)))
	elif attr == "health":
		if modifier == "sum":
			unit.add_bonus_health(value)
		elif modifier == "mult":
			unit.add_bonus_health(int(unit.curr_health * (value - 1.0)))

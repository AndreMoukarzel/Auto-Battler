extends Node3D

signal column_done
signal battle_done

enum STATES {PreBattle, Battle, PostBattle, End}

var curr_state = STATES.PreBattle
var action_priority: Array = [] # Stores actions tuples of [actor, action, actor's army]


func reset():
	$Army1.reset_troops()
	$Army2.reset_troops()
	curr_state = STATES.PreBattle
	
	for army in [$Army1, $Army2]:
		for unit in army.units:
			if unit != null:
				if len(unit.on_hit) > 0:
					unit.was_damaged.connect(insert_on_front_effects.bind(unit, unit.on_hit))
				if len(unit.on_death) > 0:
					unit.died.connect(insert_on_front_effects.bind(unit, unit.on_death))


func get_other_army(army):
	# Returns the Army that is not the one received
	if army == $Army1:
		return $Army2
	return $Army1


func insert_on_front_effects(actor, effects_list: Array):
	for effect in effects_list:
		action_priority.push_front([[actor, effect]])


func insert_on_front(actor, action):
	action_priority.push_front([[actor, action]])


func insert_on_back(actor, action):
	action_priority.push_back([[actor, action]])


func insert_simultaneous(actor1, action1, actor2, action2):
	action_priority.push_back([
		[actor1, action1],
		[actor2, action2]
	])


func execute_all_effects():
	while len(action_priority) > 0:
		for action in action_priority.pop_front():
			$EffectHandler.execute(
				action[0], action[1], action[0].army, get_other_army(action[0].army)
			)
		await get_tree().create_timer(.5).timeout 


func acting_turn() -> Array:
	var active_units = $PriorityDealer.get_active_units()
	
	if active_units[0] == null and active_units[1] == null:
		emit_signal("column_done")
		$PriorityDealer.next_column()
		if $PriorityDealer.current_column == 0:
			@warning_ignore("int_as_enum_without_cast")
			curr_state += 1
			$PriorityDealer.done_units = []
		return []
	return active_units


func effect_step(effect_array: String):
	var active_units = acting_turn()
	
	if active_units.is_empty(): # Turn of column ended
		return
	
	if active_units[0] != null and active_units[1] != null:
		# Highlights units positions
		active_units[0].army.highlight_position(active_units[0].unit_position)
		active_units[1].army.highlight_position(active_units[1].unit_position)
		
		# Adds effects to action order
		var effects1 = active_units[0].get(effect_array)
		var effects2 = active_units[1].get(effect_array)
		var max_effects: int = max(len(effects1), len(effects2))
		for i in range(max_effects):
			# If units have multiple effects, they are executed simultaniously
			# if they have the same position in the effects array
			if i < len(effects1) and i < len(effects2):
				insert_simultaneous(
					active_units[0], effects1[i],
					active_units[1], effects2[i]
				)
			elif i >= len(effects2):
				insert_on_back(active_units[0], effects1[i])
			else:
				insert_on_back(active_units[1], effects2[i])
		
		# After executing the effects, those units will not act anymore
		$PriorityDealer.done(active_units[0])
		$PriorityDealer.done(active_units[1])
	else:
		for unit in active_units:
			if unit != null:
				# Highlights units positions
				unit.army.highlight_position(unit.unit_position)
				# Hides highlight of army with no acting unit
				get_other_army(unit.army).hide_highlight()
				
				# Adds effects to action order
				for effect in unit.get(effect_array):
					insert_on_back(unit, effect)
				
				# After executing the effects, the unit will not act anymore
				$PriorityDealer.done(unit)


func battle_step():
	var active_units = acting_turn()
	
	if active_units.is_empty(): # Turn of column ended
		return
	
	var unit1 = active_units[0]
	var unit2 = active_units[1]
	
	if unit1 != null and unit2 != null:
		$Army1.highlight_position(unit1.unit_position)
		$Army2.highlight_position(unit2.unit_position)
		for effect in unit1.on_attack:
			$EffectHandler.execute(unit1, effect, $Army1, $Army2)
		for effect in unit2.on_attack:
			$EffectHandler.execute(unit2, effect, $Army2, $Army1)
		unit1.damage(unit2.curr_attack)
		unit2.damage(unit1.curr_attack)
		for effect in unit1.on_hit:
			$EffectHandler.execute(unit1, effect, $Army1, $Army2)
		for effect in unit2.on_hit:
			$EffectHandler.execute(unit2, effect, $Army2, $Army1)
	
	if unit1 != null and unit1.is_dead():
		$Army1.kill_unit(unit1.unit_position)
	if unit2 != null and unit2.is_dead():
		$Army2.kill_unit(unit2.unit_position)
	
	# Direct hits to player
	if unit1 != null and unit2 == null:
		$Army1.highlight_position(unit1.unit_position)
		for effect in unit1.on_attack:
			$EffectHandler.execute(unit1, effect, $Army1, $Army2)
		$Army1.kill_unit(unit1.unit_position)
	elif unit1 == null and unit2 != null:
		$Army2.highlight_position(unit2.unit_position)
		for effect in unit2.on_attack:
			$EffectHandler.execute(unit2, effect, $Army2, $Army1)
		# TODO: Direct damage to player
		#%PlayerHealth.text = str(int(%PlayerHealth.text) - unit2.curr_attack)
		$Army2.kill_unit(unit2.unit_position)


func progress_battle():
	if curr_state == STATES.PreBattle:
		effect_step("pre_battle")
	elif curr_state == STATES.Battle:
		battle_step()
	elif curr_state == STATES.PostBattle:
		effect_step("post_battle")
	elif curr_state == STATES.End:
		emit_signal("battle_done")
	execute_all_effects()

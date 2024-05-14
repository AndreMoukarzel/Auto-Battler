extends Node3D

signal column_done
signal battle_done

enum STATES {PreBattle, Battle, PostBattle, End}

var curr_state = STATES.PreBattle


func reset():
	$Army1.reset_troops()
	$Army2.reset_troops()
	curr_state = STATES.PreBattle


func acting_turn() -> Array:
	var active_units = $PriorityDealer.get_active_units()
	
	if active_units[0] == null and active_units[1] == null:
		emit_signal("column_done")
		$PriorityDealer.next_column()
		if $PriorityDealer.current_column == 0:
			curr_state += 1
			$PriorityDealer.done_units = []
		return []
	return active_units


func pre_battle_step():
	var active_units = acting_turn()
	
	if active_units.is_empty(): # Turn of column ended
		return
	
	var i: int = 0
	for unit in active_units:
		if unit != null:
			for effect in unit.pre_battle:
				if i == 0:
					$EffectHandler.execute(unit, effect, $Army1, $Army2)
				else:
					$EffectHandler.execute(unit, effect, $Army2, $Army1)
			$PriorityDealer.done(unit)
		i += 1


func battle_step():
	var active_units = acting_turn()
	
	if active_units.is_empty(): # Turn of column ended
		return
	
	var unit1: InstancedUnit = active_units[0]
	var unit2: InstancedUnit = active_units[1]
	
	if unit1 != null and unit2 != null:
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
		$Army1.kill_unit(unit1.position)
	if unit2 != null and unit2.is_dead():
		$Army2.kill_unit(unit2.position)
	
	# Direct hits to player
	if unit1 != null and unit2 == null:
		for effect in unit1.on_attack:
			$EffectHandler.execute(unit1, effect, $Army1, $Army2)
		$Army1.kill_unit(unit1.position)
	elif unit1 == null and unit2 != null:
		for effect in unit2.on_attack:
			$EffectHandler.execute(unit2, effect, $Army2, $Army1)
		%PlayerHealth.text = str(int(%PlayerHealth.text) - unit2.curr_attack)
		$Army2.kill_unit(unit2.position)


func post_battle_step():
	var active_units = acting_turn()
	
	if active_units.is_empty(): # Turn of column ended
		return
	
	var i: int = 0
	for unit in active_units:
		if unit != null:
			for effect in unit.post_battle:
				if i == 0:
					$EffectHandler.execute(unit, effect, $Army1, $Army2)
				else:
					$EffectHandler.execute(unit, effect, $Army2, $Army1)
			$PriorityDealer.done(unit)
		i += 1


func _on_go_pressed():
	if curr_state == STATES.PreBattle:
		pre_battle_step()
	elif curr_state == STATES.Battle:
		battle_step()
	elif curr_state == STATES.PostBattle:
		post_battle_step()
	elif curr_state == STATES.End:
		emit_signal("battle_done")

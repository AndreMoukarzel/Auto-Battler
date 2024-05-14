extends Node3D

signal column_done
signal battle_done

enum STATES {PreBattle, Attack, PostBattle}

var curr_state = STATES.PreBattle


func reset():
	$Army1.reset_troops()
	$Army2.reset_troops()
	curr_state = STATES.PreBattle


func pre_battle_step():
	var active_units = $PriorityDealer.get_active_units()
	
	if active_units[0] == null and active_units[1] == null:
		emit_signal("column_done")
		$PriorityDealer.next_column()
		if $PriorityDealer.current_column == 0:
			curr_state = STATES.Attack
			$PriorityDealer.done_units = []
	
	var i: int = 0
	for unit in active_units:
		if unit != null:
			for effect in unit.pre_battle:
				print(effect)
				print(i)
				if i == 0:
					$EffectHandler.execute(unit, effect, $Army1, $Army2)
				else:
					$EffectHandler.execute(unit, effect, $Army2, $Army1)
			$PriorityDealer.done(unit)
		i += 1


func battle_step():
	var active_units = $PriorityDealer.get_active_units()
	var unit1 = active_units[0]
	var unit2 = active_units[1]
	
	if unit1 != null and unit2 != null:
		unit1.curr_health -= unit2.curr_attack
		unit2.curr_health -= unit1.curr_attack
	
	if unit1 != null and unit1.curr_health <= 0:
		$Army1.kill_unit(unit1.position)
	if unit2 != null and unit2.curr_health <= 0:
		$Army2.kill_unit(unit2.position)
	
	# Direct hits to player
	if unit1 != null and unit2 == null:
		$Army1.kill_unit(unit1.position)
	elif unit1 == null and unit2 != null:
		%PlayerHealth.text = str(int(%PlayerHealth.text) - unit2.curr_attack)
		$Army2.kill_unit(unit2.position)


func _on_go_pressed():
	if curr_state == STATES.PreBattle:
		pre_battle_step()
	else:
		battle_step()
		var active_units = $PriorityDealer.get_active_units()
		if active_units[0] == null and active_units[1] == null:
			emit_signal("column_done")
			$PriorityDealer.next_column()
			if $PriorityDealer.current_column == 0:
				emit_signal("battle_done")

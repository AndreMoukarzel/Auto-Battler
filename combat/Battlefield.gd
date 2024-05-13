extends Node3D

signal column_done
signal battle_done
signal reset


func _ready():
	for i in range(3):
		var new_unit = load("res://units/BaseUnit.tscn").instantiate()
		new_unit.modulate = Color(0, 0, 1)
		$Army1.add_unit(new_unit, i)
	var unit = load("res://units/BaseUnit.tscn").instantiate()
	unit.modulate = Color(0, 0, 1)
	$Army1.add_unit(unit, 5)
	for i in range(5):
		var new_unit = load("res://units/BaseUnit.tscn").instantiate()
		new_unit.modulate = Color(1, 0, 0)
		$Army2.add_unit(new_unit, i)
	$Army1.reset_troops()
	$Army2.reset_troops()


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
	battle_step()
	var active_units = $PriorityDealer.get_active_units()
	if active_units[0] == null and active_units[1] == null:
		emit_signal("column_done")
		$PriorityDealer.next_column()
		if $PriorityDealer.current_column == 0:
			emit_signal("battle_done")


func _on_reset_pressed():
	$Army1.reset_troops()
	$Army2.reset_troops()
	emit_signal("reset")

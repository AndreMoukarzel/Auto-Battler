extends Node


@onready var army1 = get_node("Army1")
@onready var army2 = get_node("Army2")


func _ready():
	for i in range(3):
		var new_unit = load("res://units/BaseUnit.tscn").instantiate()
		army1.add_unit(new_unit, i)
	for i in range(5):
		var new_unit = load("res://units/BaseUnit.tscn").instantiate()
		army2.add_unit(new_unit, i)


func pre_combat(unit_position: int):
	pass


func combat():
	for unit_position in range(6):
		pre_combat(unit_position)
	for unit_position in range(6):
		act(unit_position)


func act(unit_position: int):
	var unit1 = army1.get_unit(unit_position)
	var unit2 = army2.get_unit(unit_position)
	
	if unit1 != null and unit2 != null:
		unit1.curr_health -= unit2.curr_attack
		unit2.curr_health -= unit1.curr_attack
	
	if unit1 != null and unit1.curr_health <= 0:
		army1.kill_unit(unit_position)
	if unit2 != null and unit2.curr_health <= 0:
		army2.kill_unit(unit_position)


func _on_go_pressed():
	combat()

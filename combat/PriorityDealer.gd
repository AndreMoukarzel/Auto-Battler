extends Node


@onready var Army1 = get_parent().get_node("Army1")
@onready var Army2 = get_parent().get_node("Army2")

var current_column: int = 0
var done_units: Array = []


func get_active_units():
	var unit1 = get_ready_unit_from_column(Army1)
	var unit2 = get_ready_unit_from_column(Army2)
	
	return [unit1, unit2]


func get_ready_unit_from_column(Army):
	var column_positions: Array = [current_column * 2, (current_column * 2) + 1]
	var unit = Army.get_unit(column_positions[0])
	
	if unit == null or unit in done_units:
		unit = Army.get_unit(column_positions[1])
		if unit in done_units:
			unit = null
	return unit


func done(unit):
	done_units.append(unit)


func next_column():
	current_column = (current_column + 1) % 3

extends Node3D

signal position_already_taken(pos: int)
signal unit_added

var InstacedUnit: PackedScene = load("res://units/InstancedUnit.tscn")

var base_units: Array = [null, null, null, null, null ,null]
var units: Array = [null, null, null, null, null ,null] # We have this array to have the liberty to delete references to units


func add_unit(unit_name: String, pos: int):
	if pos >= len(base_units):
		push_error("Invalid unit position")
		return
	if base_units[pos] != null:
		push_warning("Position " + str(pos) + " already taken")
		emit_signal("position_already_taken", pos)
		return
	
	var new_unit = InstacedUnit.instantiate()
	new_unit.configure(unit_name, pos)
	base_units[pos] = new_unit
	get_node("Position" + str(pos)).add_child(new_unit)
	
	emit_signal("unit_added")


func reset_troops():
	for pos in range(len(base_units)):
		get_node("Position" + str(pos)).show()
		if base_units[pos] != null:
			base_units[pos].reset()
		units[pos] = base_units[pos]
		#if units[pos] != null:
		#	get_node("Position" + str(pos)).add_child(units[pos].sprite.duplicate())


func get_unit(pos: int):
	return units[pos]


func kill_unit(pos: int):
	units[pos] = null
	get_node("Position" + str(pos)).hide()

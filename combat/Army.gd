extends Node3D

signal position_already_taken(pos: int)
signal unit_added


var base_units: Array = [null, null, null, null, null ,null]
var units: Array = [null, null, null, null, null ,null] # We have this array to have the liberty to delete references to units


func add_unit(unit: String, pos: int):
	if pos >= len(base_units):
		push_error("Invalid unit position")
		return
	if base_units[pos] != null:
		push_warning("Position " + str(pos) + " already taken")
		emit_signal("position_already_taken", pos)
		return
	
	base_units[pos] = InstancedUnit.new(unit, pos)
	
	emit_signal("unit_added")


func reset_troops():
	for pos in range(len(base_units)):
		if base_units[pos] != null:
			base_units[pos].reset()
		units[pos] = base_units[pos]
		if units[pos] != null:
			get_node("Position" + str(pos)).add_child(units[pos].sprite.duplicate())


func get_unit(pos: int):
	return units[pos]


## Returns if the unit in the specified position is able to act.
func unit_is_able(pos: int) -> bool:
	if units[pos] == null:
		return false
	if pos % 2 == 1 and units[pos - 1] != null: # If in backline is blocked by an unit in front, can't attack
		return false
	return true


func kill_unit(pos: int):
	units[pos] = null
	get_node("Position" + str(pos)).get_children()[0].queue_free()

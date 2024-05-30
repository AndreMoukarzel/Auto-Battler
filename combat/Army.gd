extends Node3D

signal position_already_taken(pos: int)
signal unit_added

var base_units: Array = [null, null, null, null, null ,null]
var units: Array = [null, null, null, null, null ,null] # We have this array to have the liberty to delete references to units


func add_unit(unit, pos: int):
	if pos >= len(base_units):
		push_error("Invalid unit position")
		return
	if base_units[pos] != null:
		push_warning("Position " + str(pos) + " already taken")
		emit_signal("position_already_taken", pos)
		return
	
	unit.unit_position = pos
	unit.army = self
	base_units[pos] = unit
	get_node("Position" + str(pos)).add_child(unit)
	
	emit_signal("unit_added")


func reset_troops():
	for pos in range(len(base_units)):
		if base_units[pos] != null:
			base_units[pos].reset()
		units[pos] = base_units[pos]
		if units[pos] != null: # Updates reference to army
			units[pos].army = self


func get_unit(pos: int):
	return units[pos]


func kill_unit(pos: int):
	units[pos].die()
	units[pos] = null
	hide_highlight()


func highlight_position(pos: int):
	$Highlight.position = get_node("Position" + str(pos)).position
	$Highlight.show()


func hide_highlight():
	$Highlight.hide()

extends Node3D

signal position_already_taken(pos: int)
signal unit_added


var units: Array = [null, null, null, null, null ,null]


func add_unit(unit: Sprite3D, pos: int):
	if pos >= len(units):
		push_error("Invalid unit position")
		return
	if units[pos] != null:
		push_warning("Position " + str(pos) + " already taken")
		emit_signal("position_already_taken", pos)
		return
	
	units[pos] = InstancedUnit.new(unit)
	get_node("Position" + str(pos)).add_child(unit)
	
	emit_signal("unit_added")


func get_unit(pos: int):
	return units[pos]


func kill_unit(pos: int):
	get_node("Position" + str(pos)).hide()


func reset():
	for pos in range(len(units)):
		get_node("Position" + str(pos)).show()

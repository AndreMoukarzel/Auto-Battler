extends Node3D


signal position_already_taken(pos: int)
signal unit_added


var currently_on: int = -1 # Position the mouse is currently hovering on
var units: Array = [null, null, null, null, null, null]


func _ready():
	for i in range(6):
		var PosNodeArea: Area3D = get_node("Position" + str(i) + "/Area3D")
		PosNodeArea.mouse_entered.connect(mouse_inside.bind(i))
		PosNodeArea.mouse_exited.connect(mouse_left.bind(i))


func mouse_inside(pos: int):
	currently_on = pos


func mouse_left(pos: int):
	if pos == currently_on:
		currently_on = -1


func get_current_pos():
	return currently_on


func add_unit(unit, pos: int):
	if pos >= len(units):
		push_error("Invalid unit position")
		return
	if units[pos] != null:
		push_warning("Position " + str(pos) + " already taken")
		emit_signal("position_already_taken", pos)
		return
	
	var PosNode: Node3D = get_node("Position" + str(pos))
	PosNode.add_child(unit)
	units[pos] = unit
	unit.unit_position = pos
	unit.global_position = PosNode.global_position
	
	emit_signal("unit_added")


func remove_unit(pos: int):
	get_node("Position" + str(pos)).remove_child(units[pos])
	units[pos] = null


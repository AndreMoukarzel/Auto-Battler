extends Node3D


var currently_on: int = -1 # Position the mouse is currently hovering on


func _ready():
	for i in range(6):
		var PosNodeArea: Area3D = get_node("Position" + str(i) + "/Area3D")
		PosNodeArea.mouse_entered.connect(mouse_inside.bind(i))


func mouse_inside(pos: int):
	print("Mouse entered " + str(pos))
	currently_on = pos


func mouse_left(pos: int):
	print("Mouse entered " + str(pos))


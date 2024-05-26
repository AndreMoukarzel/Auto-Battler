extends Node3D


var InstacedUnit: PackedScene = preload("res://units/InstancedUnit.tscn")


func _ready():
	var new_unit = InstacedUnit.instantiate()
	new_unit.configure("Archer")
	
	$PlayerTroops.add_unit(new_unit, 0)
	
	var new_unit2 = InstacedUnit.instantiate()
	new_unit2.configure("Runic Master")
	
	$PlayerTroops.add_unit(new_unit2, 4)

extends Node3D


var InstacedUnit: PackedScene = preload("res://units/InstancedUnit.tscn")

var money: int = 10:
	set(value):
		money = value
		$HUD/Info/Money/Label.text = str(money)


func _ready():
	var new_unit = InstacedUnit.instantiate()
	new_unit.configure("Archer")
	
	$PlayerTroops.add_unit(new_unit, 0)
	
	var new_unit2 = InstacedUnit.instantiate()
	new_unit2.configure("Runic Master")
	
	$PlayerTroops.add_unit(new_unit2, 4)


func _on_reroll_button_up():
	if money >= 3:
		money -= 3
		$PlayerHand/Store.clear()
		$PlayerHand/Store.refill()

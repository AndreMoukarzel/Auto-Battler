extends Node3D


func _ready():
	$Battlefield/Army1.add_unit("Berserker", 0)
	$Battlefield/Army1.add_unit("Runic Master", 1)
	$Battlefield/Army1.add_unit("Bullwark", 3)
	$Battlefield/Army1.add_unit("Archer", 4)
	
	$Battlefield/Army2.add_unit("Bullwark", 0)
	$Battlefield/Army2.add_unit("Archer", 1)
	$Battlefield/Army2.add_unit("Runic Master", 2)
	$Battlefield/Army2.add_unit("Archer", 3)
	$Battlefield/Army2.add_unit("Bullwark", 4)

	$Battlefield.reset()


func _on_battlefield_battle_done():
	$UI/Buttons/Go.disabled = true
	$UI/Buttons/Reset.disabled = false


func _on_reset_pressed():
	$Battlefield.reset()
	$UI/Buttons/Go.disabled = false
	$UI/Buttons/Reset.disabled = true

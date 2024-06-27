extends Node3D

signal to_battle


var InstacedUnit: PackedScene = preload("res://units/InstancedUnit.tscn")

var money: int = 10:
	set(value):
		money = value
		$HUD/Info/Money/Label.text = str(money)


func reset():
	money = 10
	$PlayerHand/Store.clean_locked() # Cleans locked StoreUnits that were bought in the previous round
	$PlayerHand/Store.clear()
	$PlayerHand/Store.refill()


## Since duplicate() does not copy the script's variable values, we must copy
## those values manually.
func copy_unit_info(from_unit, to_unit):
	to_unit.base_attack = from_unit.base_attack
	to_unit.base_health = from_unit.base_health
	to_unit.bonus_attack = from_unit.bonus_attack
	to_unit.bonus_health = from_unit.bonus_health
	
	to_unit.level = from_unit.level
	
	to_unit.pre_battle = from_unit.pre_battle
	to_unit.on_attack = from_unit.on_attack
	to_unit.on_hit = from_unit.on_hit
	to_unit.post_battle = from_unit.post_battle
	to_unit.on_death = from_unit.on_death


func get_troops():
	var units_copy = []
	for unit in $PlayerTroops.units:
		if unit != null:
			# We duplicate the InstancedUnits to be able to add them as children of the battle scene
			var unit_clone = unit.duplicate()
			copy_unit_info(unit, unit_clone)
			units_copy.append(unit_clone)
		else:
			units_copy.append(null)
	return units_copy


func transition_to_battle():
	$CameraAnimation.play("to_battle")
	for stand in $PlayerTroops.get_children():
		stand.launch()


func reset_animations():
	$CameraAnimation.play("RESET")
	for stand in $PlayerTroops.get_children():
		stand.position.y = 0
		stand.show()


func _on_reroll_button_up():
	if money >= 1:
		money -= 1
		$PlayerHand/Store.clear()
		$PlayerHand/Store.refill()


func _on_to_battle_button_up():
	emit_signal("to_battle")

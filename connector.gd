extends Node3D


var InstacedUnit: PackedScene = preload("res://units/InstancedUnit.tscn")


func _on_buy_phase_to_battle():
	var player_units = $BuyPhase.get_troops()
	$BuyPhase.hide()
	$BuyPhase/HUD.hide()
	$BuyPhase/PlayerHand.hide()
	var enemy_units = get_enemy_units()
	
	$Battle.show()
	$BuyPhase/Camera3D.current = false
	$Battle/Camera3D.current = true
	$Battle.setup_armies(player_units, enemy_units)
	$BattleUI.show()


func _on_battle_to_buy_phase():
	$BattleUI.hide()
	$Battle.hide()
	
	$Battle/Camera3D.current = false
	$BuyPhase/Camera3D.current = true
	
	$BuyPhase.reset()
	$BuyPhase.show()
	$BuyPhase/HUD.show()
	$BuyPhase/PlayerHand.show()


func get_enemy_units():
	var instanced_units = []
	var arbitrary_units = ["Bullwark", "Archer", "Runic Master", "Archer", null, "Berserker"]
	for i in range(len(arbitrary_units)):
		if arbitrary_units[i] != null:
			var Unit = InstacedUnit.instantiate()
			Unit.configure(arbitrary_units[i])
			instanced_units.append(Unit)
		else:
			instanced_units.append(null)
	return instanced_units


func _on_battle_battle_done():
	$BattleUI/EndBattle.disabled = false


func _on_end_battle_button_up():
	_on_battle_to_buy_phase()

extends Node3D


var InstacedUnit: PackedScene = preload("res://units/InstancedUnit.tscn")


func _on_buy_phase_to_battle():
	# Start transition animation
	$BuyPhase/HUD.hide()
	$BuyPhase/PlayerHand.hide()
	$BuyPhase/Camera3D/AnimationPlayer.play("to_battle")
	await $BuyPhase/Camera3D/AnimationPlayer.animation_finished
	
	# At the end, hides Buy scene and reveals battle
	$BuyPhase.hide()
	
	var player_units = $BuyPhase.get_troops()
	var enemy_units = get_enemy_units()
	$Battle.show()
	$BuyPhase/Camera3D.current = false
	$Battle/Camera3D.current = true
	$Battle.setup_armies(player_units, enemy_units)
	$BattleUI.show()
	
	$BuyPhase/Camera3D/AnimationPlayer.play("RESET")


func _on_battle_to_buy_phase():
	$BattleUI.hide()
	$Battle.hide()
	
	$Battle.clear_armies()
	
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

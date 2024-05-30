extends Node3D



func _on_battlefield_battle_done():
	$BattleUI/Buttons/Reset.disabled = false


func _on_reset_pressed():
	$BattleUI/Buttons/Reset.disabled = true


func setup_armies(player_units: Array, enemy_units: Array):
	for i in range(len(player_units)):
		if player_units[i] != null:
			$Battlefield/Army1.add_unit(player_units[i], i)
		if enemy_units[i] != null:
			$Battlefield/Army2.add_unit(enemy_units[i], i)
	$Battlefield.reset()
	
	await get_tree().create_timer(1.5).timeout
	$BattleTimer.start()


func _on_battle_timer_timeout():
	$Battlefield.progress_battle()

extends Node3D


func _on_battlefield_battle_done():
	$UI/Buttons/Go.disabled = true
	$UI/Buttons/Reset.disabled = false


func _on_battlefield_reset():
	$UI/Buttons/Go.disabled = false
	$UI/Buttons/Reset.disabled = true

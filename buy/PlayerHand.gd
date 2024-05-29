extends Control


@onready var PlayerTroops: Node3D = get_parent().get_node("PlayerTroops")


var unit_origin_position: int = -1
var holding_unit: # Held InstancedUnit
	get:
		return holding_unit
	set(unit):
		holding_unit = unit
		if unit == null:
			$Holding.hide()
		else:
			$Holding.texture = unit.get_texture()
			$Holding.show()


func _input(event):
	if event is InputEventMouseButton:
		var selected_pos: int = PlayerTroops.get_current_pos()
		if event.pressed:
			if selected_pos != -1 and PlayerTroops.units[selected_pos] != null: # Getting hold of placed unit
				unit_origin_position = selected_pos
				holding_unit = PlayerTroops.units[selected_pos]
				PlayerTroops.remove_unit(selected_pos)
		else: # Mouse released
			if selected_pos != -1 and holding_unit != null:
				if PlayerTroops.units[selected_pos] == null: # Placing unit in empty spot
					PlayerTroops.add_unit(holding_unit, selected_pos)
				elif unit_origin_position != -1: # Swaping existing PlayerTroop units (Store units do not set unit_origin_position)
					var temp_unit =  PlayerTroops.units[selected_pos]
					PlayerTroops.remove_unit(selected_pos)
					PlayerTroops.add_unit(holding_unit, selected_pos)
					PlayerTroops.add_unit(temp_unit, unit_origin_position)
			else: # Selling unit
				pass
			holding_unit = null


func _process(_delta):
	var text_half_size: Vector2 = $Holding.size/2
	$Holding.set_position(get_viewport().get_mouse_position() - text_half_size)


func get_from_store(SUnit):
	holding_unit = SUnit.unit


func release_from_store(SUnit):
	var selected_pos: int = PlayerTroops.get_current_pos()
	if selected_pos == -1: # Release in dead space. Unit goes back to Store
		return
	if PlayerTroops.units[selected_pos] == null: # Placing unit in empty spot
		PlayerTroops.add_unit(SUnit.unit, selected_pos)
		SUnit.queue_free()
	else: # Placing unit over existing unit
		PlayerTroops.remove_unit(selected_pos)
		PlayerTroops.add_unit(SUnit.unit, selected_pos)
		SUnit.queue_free()

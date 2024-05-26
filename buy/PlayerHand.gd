extends Control


@onready var PlayerTroops: Node3D = get_parent().get_node("PlayerTroops")


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
			if selected_pos != -1 and PlayerTroops.units[selected_pos] != null:
				holding_unit = PlayerTroops.units[selected_pos]
				PlayerTroops.remove_unit(selected_pos)
		else: # Mouse released
			if selected_pos != -1:
				if PlayerTroops.units[selected_pos] == null: # Placing unit in empty spot
					PlayerTroops.add_unit(holding_unit, selected_pos)
				else: # Placing unit over existing unit
					pass 
			else: # Selling unit
				pass
			holding_unit = null


func _process(_delta):
	var text_half_size: Vector2 = $Holding.size/2
	$Holding.set_position(get_viewport().get_mouse_position() - text_half_size)
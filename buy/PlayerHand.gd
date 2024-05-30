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
				get_from_troops(selected_pos)
		else: # Mouse released
			if selected_pos != -1 and holding_unit != null and unit_origin_position != -1: # Placing unit from Troops (Store units do not set unit_origin_position)
				place_from_troops(selected_pos)
			elif holding_unit != null and unit_origin_position != -1: # Selling unit
				sell_unit(holding_unit)
			holding_unit = null
			unit_origin_position = -1


func _process(_delta):
	var text_half_size: Vector2 = $Holding.size/2
	$Holding.set_position(get_viewport().get_mouse_position() - text_half_size)


func sell_unit(Unit):
	get_parent().money += 1


func get_from_troops(unit_pos: int):
	unit_origin_position = unit_pos
	holding_unit = PlayerTroops.units[unit_pos]
	PlayerTroops.remove_unit(unit_pos)


func place_from_troops(placing_pos: int):
	if PlayerTroops.units[placing_pos] != null: # Swaping existing PlayerTroop units
		var temp_unit =  PlayerTroops.units[placing_pos]
		PlayerTroops.remove_unit(placing_pos)
		PlayerTroops.add_unit(temp_unit, unit_origin_position)
	PlayerTroops.add_unit(holding_unit, placing_pos)


func get_from_store(SUnit):
	holding_unit = SUnit.unit


func release_from_store(SUnit):
	var selected_pos: int = PlayerTroops.get_current_pos()
	if selected_pos == -1: # Release in dead space. Unit goes back to Store
		return
	if get_parent().money < 3:
		return
	get_parent().money -= 3
	if PlayerTroops.units[selected_pos] == null: # Placing unit in empty spot
		PlayerTroops.add_unit(SUnit.unit, selected_pos)
		SUnit.queue_free()
	else: # Placing unit over existing unit
		sell_unit(PlayerTroops.units[selected_pos])
		PlayerTroops.remove_unit(selected_pos)
		PlayerTroops.add_unit(SUnit.unit, selected_pos)
		SUnit.queue_free()

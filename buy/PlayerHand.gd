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
	get_parent().money += Unit.level


## Checks if unit2 can be merged into unit1
func can_merge(unit1, unit2) -> bool:
	if unit1.level == 3 or unit2.level == 3: # Unit already at max level
		return false
	if unit1.unit_name != unit2.unit_name: # They are different units. What are you thinking?
		return false
	return true


func get_from_troops(unit_pos: int):
	unit_origin_position = unit_pos
	holding_unit = PlayerTroops.units[unit_pos]
	PlayerTroops.remove_unit(unit_pos)


func place_from_troops(placing_pos: int):
	if PlayerTroops.units[placing_pos] != null: # Placing unit over existing unit
		var curr_unit = PlayerTroops.units[placing_pos]
		if can_merge(curr_unit, holding_unit):
			for i in range(holding_unit.level):
				curr_unit.add_experience()
		else: # Swaping existing PlayerTroop units
			PlayerTroops.remove_unit(placing_pos)
			PlayerTroops.add_unit(curr_unit, unit_origin_position)
	PlayerTroops.add_unit(holding_unit, placing_pos)


func get_from_store(SUnit):
	holding_unit = SUnit.unit


func unlock_store_unit(SUnit):
	if SUnit in $Store.locked:
		$Store.lock(SUnit)


func release_from_store(SUnit):
	var selected_pos: int = PlayerTroops.get_current_pos()
	if selected_pos == -1: # Release in dead space. Unit goes back to Store
		return
	if get_parent().money < 3:
		return
	get_parent().money -= 3
	if PlayerTroops.units[selected_pos] == null: # Placing unit in empty spot
		PlayerTroops.add_unit(SUnit.unit, selected_pos)
		unlock_store_unit(SUnit)
		SUnit.queue_free()
	else: # Placing unit over existing unit
		var curr_unit = PlayerTroops.units[selected_pos]
		if can_merge(curr_unit, SUnit.unit):
			for i in range(SUnit.unit.level):
				curr_unit.add_experience()
		else:
			sell_unit(PlayerTroops.units[selected_pos])
			PlayerTroops.remove_unit(selected_pos)
			PlayerTroops.add_unit(SUnit.unit, selected_pos)
		unlock_store_unit(SUnit)
		SUnit.queue_free()

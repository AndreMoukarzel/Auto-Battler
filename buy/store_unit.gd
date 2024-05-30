extends TextureRect

signal pressed
signal released
signal locked

var unit:
	get:
		return unit
	set(instanced_unit):
		unit = instanced_unit
		self.texture = instanced_unit.get_texture()
		$Attack.text = str(instanced_unit.curr_attack)
		$Health.text = str(instanced_unit.curr_health)


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1: # Left mouse button
			if event.pressed:
				emit_signal("pressed")
			else:
				emit_signal("released")
		elif event.button_index == 2 and event.pressed: # Right mouse button
			emit_signal("locked")


func disable(boolean: bool=true):
	if boolean:
		self.modulate = Color(0.2, 0.2, 0.2, 0.5)
		$Attack.hide()
		$Health.hide()
	else:
		self.modulate = Color(1., 1., 1., 1.)
		$Attack.show()
		$Health.show()


func lock(boolean: bool=true):
	if boolean:
		$Lock.show()
	else:
		$Lock.hide()

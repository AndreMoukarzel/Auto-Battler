extends TextureRect

signal pressed
signal released

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
		if event.pressed:
			emit_signal("pressed")
		else:
			emit_signal("released")


func disable(boolean: bool=true):
	if boolean:
		self.modulate = Color(0.2, 0.2, 0.2, 0.5)
		$Attack.hide()
		$Health.hide()
	else:
		self.modulate = Color(1., 1., 1., 1.)
		$Attack.show()
		$Health.show()

extends TextureRect


var unit:
	get:
		return unit
	set(instanced_unit):
		unit = instanced_unit
		self.texture = instanced_unit.get_texture()
		$Attack.text = str(instanced_unit.curr_attack)
		$Health.text = str(instanced_unit.curr_health)

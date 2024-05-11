class_name InstancedUnit

var sprite: Sprite3D = null
var base_attack: int
var base_health: int
var position: int

var curr_attack: int
var curr_health: int


func _init(unit, pos: int):
	sprite = unit
	base_attack = unit.attack
	base_health = unit.health
	position = pos
	reset()


func reset():
	curr_attack = base_attack
	curr_health = base_health

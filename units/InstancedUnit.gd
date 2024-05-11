class_name InstancedUnit

var base_attack: int
var base_health: int

var curr_attack: int
var curr_health: int


func _init(unit):
	base_attack = unit.attack
	base_health = unit.health
	reset()


func reset():
	curr_attack = base_attack
	curr_health = base_health

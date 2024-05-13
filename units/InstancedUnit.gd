class_name InstancedUnit

var sprite: Sprite3D = null
var base_attack: int
var base_health: int
var position: int

var curr_attack: int
var curr_health: int


func _init(unit: String, pos: int):
	var unit_data = UnitsData.Database[unit]
	
	base_attack = unit_data["Attack"]
	base_health = unit_data["Health"]
	position = pos
	
	sprite = Sprite3D.new()
	sprite.texture = load(unit_data["Sprite"])
	sprite.scale = Vector3(0.2, 0.2, 0.2)
	reset()


func reset():
	curr_attack = base_attack
	curr_health = base_health

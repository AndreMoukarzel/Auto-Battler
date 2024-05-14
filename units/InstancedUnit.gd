class_name InstancedUnit

var name: String
var sprite: Sprite3D
var base_attack: int
var base_health: int
var position: int

var pre_battle: Array = []
var on_attack: Array = []
var on_hit: Array = []
var post_battle: Array = []
var on_death: Array = []

var bonus_attack: int = 0 # Lasts only until a round reset
var bonus_health: int = 0 # Lasts only until a round reset

var curr_attack: int
var curr_health: int


func _init(unit: String, pos: int):
	var unit_data = UnitsData.Database[unit]
	name = unit
	position = pos
	
	base_attack = unit_data["Attack"]
	base_health = unit_data["Health"]
	
	pre_battle = unit_data["PreBattle"] if unit_data.has("PreBattle") else []
	on_attack = unit_data["OnAttack"] if unit_data.has("OnAttack") else []
	
	sprite = Sprite3D.new()
	sprite.texture = load(unit_data["Sprite"])
	sprite.scale = Vector3(0.2, 0.2, 0.2)
	reset()


func add_bonus_attack(value: int):
	bonus_attack += value
	curr_attack = base_attack + bonus_attack


func add_bonus_health(value: int):
	bonus_health += value
	curr_health = base_health + bonus_health


func reset():
	curr_attack = base_attack
	curr_health = base_health
	
	bonus_attack = 0
	bonus_health = 0

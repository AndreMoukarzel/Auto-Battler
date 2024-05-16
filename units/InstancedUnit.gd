extends Node3D

class_name InstancedUnit

var unit_name: String
var sprite: Sprite3D
var base_attack: int
var base_health: int
var unit_position: int

var pre_battle: Array = []
var on_attack: Array = []
var on_hit: Array = []
var post_battle: Array = []
var on_death: Array = []

var bonus_attack: int = 0 # Lasts only until a round reset
var bonus_health: int = 0 # Lasts only until a round reset

var curr_attack: int :
	get:
		return curr_attack
	set(value):
		curr_attack = value
		$Attack/AnimationPlayer.play("bounce")
		$Attack.text = str(curr_attack)
var curr_health: int :
	get:
		return curr_health
	set(value):
		curr_health = max(0, value)
		$Health/AnimationPlayer.play("bounce")
		$Health.text = str(curr_health)


func configure(unit: String, pos: int):
	var unit_data = UnitsData.Database[unit]
	unit_name = unit
	unit_position = pos
	
	base_attack = unit_data["Attack"]
	base_health = unit_data["Health"]
	
	pre_battle = unit_data["PreBattle"] if unit_data.has("PreBattle") else []
	on_attack = unit_data["OnAttack"] if unit_data.has("OnAttack") else []
	
	$Sprite3D.texture = load(unit_data["Sprite"])
	reset()


func add_bonus_attack(value: int):
	bonus_attack += value
	curr_attack = base_attack + bonus_attack


func add_bonus_health(value: int):
	bonus_health += value
	curr_health = base_health + bonus_health


func damage(value: int):
	curr_health = max(0, curr_health - value)


func die():
	$Sprite3D/AnimationPlayer.play("die")
	$Health.hide()
	$Attack.hide()


func is_dead() -> bool:
	return curr_health <= 0


func reset():
	curr_attack = base_attack
	curr_health = base_health
	
	bonus_attack = 0
	bonus_health = 0
	
	$Sprite3D/AnimationPlayer.play("RESET")
	$Health.show()
	$Attack.show()

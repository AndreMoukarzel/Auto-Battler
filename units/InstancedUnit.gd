extends Node3D

class_name InstancedUnit

signal was_damaged
signal died

var unit_name: String
var unit_position: int
var army: Node3D
var base_attack: int
var base_health: int

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
		$Health/AnimationPlayer.stop(true)
		$Attack/AnimationPlayer.play("bounce")
		$Attack.text = str(curr_attack)
var curr_health: int :
	get:
		return curr_health
	set(value):
		curr_health = max(0, value)
		$Health/AnimationPlayer.stop(true)
		$Health/AnimationPlayer.play("bounce")
		$Health.text = str(curr_health)


func configure(unit: String, pos: int=-1, owner_army: Node3D=null):
	var unit_data = UnitsData.Database[unit]
	unit_name = unit
	unit_position = pos
	army = owner_army
	
	base_attack = unit_data["Attack"]
	base_health = unit_data["Health"]
	
	pre_battle = unit_data["PreBattle"] if unit_data.has("PreBattle") else []
	on_attack = unit_data["OnAttack"] if unit_data.has("OnAttack") else []
	on_hit = unit_data["OnHit"] if unit_data.has("OnHit") else []
	post_battle = unit_data["PostBattle"] if unit_data.has("PostBattle") else []
	on_death = unit_data["OnDeath"] if unit_data.has("OnDeath") else []
	
	$Sprite3D.texture = load(unit_data["Sprite"])
	reset()


func get_texture():
	return $Sprite3D.texture


func add_bonus_attack(value: int):
	bonus_attack += value
	curr_attack = base_attack + bonus_attack


func add_bonus_health(value: int):
	bonus_health += value
	curr_health = base_health + bonus_health


func damage(value: int):
	curr_health = max(0, curr_health - value)
	emit_signal("was_damaged")


func die():
	$Sprite3D/AnimationPlayer.play("die")
	$Health.hide()
	$Attack.hide()
	emit_signal("died")


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

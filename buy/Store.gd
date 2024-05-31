extends Control


var InstacedUnit: PackedScene = preload("res://units/InstancedUnit.tscn")
var StoreUnit: PackedScene = preload("res://buy/store_unit.tscn")

var unit_names: Array = UnitsData.Database.keys()

var locked: Array = [] # Index of units locked from randomizing


func _ready():
	randomize()
	refill()


func refill():
	for i in range(5 - len(locked)): # Create 5 random units in store
		var rand_unit_name = unit_names[randi_range(0, len(unit_names) - 1)]
		var Unit = InstacedUnit.instantiate()
		var SUnit = StoreUnit.instantiate()
		
		Unit.configure(rand_unit_name)
		SUnit.unit = Unit
		
		$AvailableUnits.add_child(SUnit)
		
		SUnit.pressed.connect(select.bind(SUnit))
		SUnit.released.connect(deselect.bind(SUnit))
		SUnit.locked.connect(lock.bind(SUnit))


func clear():
	for child in $AvailableUnits.get_children():
		if not child in locked:
			child.queue_free()


func select(SUnit):
	SUnit.disable()
	get_parent().get_from_store(SUnit)


func deselect(SUnit):
	SUnit.disable(false)
	get_parent().release_from_store(SUnit)


func lock(SUnit):
	if SUnit in locked:
		SUnit.lock(false)
		locked.remove_at(locked.find(SUnit))
	else:
		SUnit.lock(true)
		locked.append(SUnit)


func unlock_all():
	for unit in locked:
		unit.lock(false)
	locked = []


func clean_locked():
	var clean = []
	for unit in locked:
		if is_instance_valid(unit):
			clean.append(unit)
	locked = clean

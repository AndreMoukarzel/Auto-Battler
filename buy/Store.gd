extends Control


var InstacedUnit: PackedScene = preload("res://units/InstancedUnit.tscn")
var StoreUnit: PackedScene = preload("res://buy/store_unit.tscn")

var unit_names: Array = UnitsData.Database.keys()


func _ready():
	randomize()
	refill()


func refill():
	for i in range(5): # Create 5 random units in store
		var rand_unit_name = unit_names[randi_range(0, len(unit_names) - 1)]
		var Unit = InstacedUnit.instantiate()
		var SUnit = StoreUnit.instantiate()
		
		Unit.configure(rand_unit_name)
		SUnit.unit = Unit
		
		$AvailableUnits.add_child(SUnit)
		
		SUnit.pressed.connect(select.bind(SUnit))
		SUnit.released.connect(deselect.bind(SUnit))


func select(SUnit):
	SUnit.disable()
	get_parent().get_from_store(SUnit)


func deselect(SUnit):
	SUnit.disable(false)
	get_parent().release_from_store(SUnit)

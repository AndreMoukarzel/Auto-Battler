extends Control


var InstacedUnit: PackedScene = preload("res://units/InstancedUnit.tscn")
var StoreUnit: PackedScene = preload("res://buy/store_unit.tscn")

var unit_names = UnitsData.Database.keys()


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

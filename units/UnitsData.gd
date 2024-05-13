class_name UnitsData

## Database containing all units of the game.
## Each unit has the actions it executes at each battle step specified in a list
## Existing actions can be the following types:
##	- Attacking
##	- Buff: Modifies the attribute of an unit. Format is ["Buff", [Attribute affected, "Sum"/"Mult", Value], [Target Army, Positions affected]]

const Database = {
	"Small": {
		"Sprite": "res://units/sprites/1.jpg",
		"Attack": 3,
		"Health": 1,
		"PreBattleActs": [],
		"BattleActs": [["Attack"]],
		"PosBattleActs": []
	},
	"Medium": {
		"Sprite": "res://units/sprites/3.jpg",
		"Attack": 2,
		"Health": 2,
		"PreBattleActs": [],
		"BattleActs": [["Attack"]],
		"PosBattleActs": []
	},
	"Large": {
		"Sprite": "res://units/sprites/4.jpg",
		"Attack": 1,
		"Health": 3,
		"PreBattleActs": [],
		"BattleActs": [["Attack"]],
		"PosBattleActs": []
	},
	"Runic Master": {
		"Sprite": "res://units/sprites/2.jpg",
		"Attack": 1,
		"Health": 1,
		"PreBattleActs": [["Buff", ["Attack", "Sum", 1], ["Ally", "Front"]]],
		"BattleActs": [["Attack"]],
		"PosBattleActs": []
	}
}

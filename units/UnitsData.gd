class_name UnitsData

## Database containing all units of the game.
## Each unit has the actions it executes at each battle step specified in a list.
## Existing battle steps are as follows:
##	- PreBattle
##	- OnAttack (Before attack)
##	- OnHit (After attack)
##	- PostBattle
##	- OnDeath
## Existing actions can be the following types:
##	- Damage: Damages its target. Format is ["Damage", Attack Power, [Target Army, Positions affected], Frequency]
##	- Buff: Modifies the attribute of an unit. Format is ["Buff", [Attribute affected, "Sum"/"Mult", Value], [Target Army, Positions affected]]

const Database = {
	"Archer": {
		"Sprite": "res://units/sprites/1.png",
		"Attack": 3,
		"Health": 1,
		"PreBattle": [["Damage", 1, ["Enemy", "Front"], 2]]
	},
	"Bullwark": {
		"Sprite": "res://units/sprites/3.png",
		"Attack": 1,
		"Health": 8,
		"OnHit": [["Buff", ["Attack", "Sum", 1], ["Ally", "Back"]]]
	},
	"Berserker": {
		"Sprite": "res://units/sprites/4.png",
		"Attack": 1,
		"Health": 3,
		"OnAttack": [["Buff", ["Attack", "Mult", 2.0], ["Ally", "Self"]]]
	},
	"Runic Master": {
		"Sprite": "res://units/sprites/2.png",
		"Attack": 1,
		"Health": 1,
		"PreBattle": [["Buff", ["Attack", "Sum", 2], ["Ally", "Front"]]]
	}
}

extends Node2D

@onready var area2D: Area2D = $Area2D

var ritualDamage: int = 4

func dealDamage():
	var bodies = area2D.get_overlapping_bodies()
	for body in bodies:
		var enemie: Enemy = body
		enemie.takeDamage(ritualDamage)

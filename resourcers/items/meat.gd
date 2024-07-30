extends Node2D

@export var healAmount: int = 10


func _on_area_2d_body_entered(body):
	var player: Player = body
	player.health += healAmount
	
	if player.health > player.maxHealth:
		player.health = player.maxHealth
	
	GameManager.catchedItem.emit("meat")
	queue_free()

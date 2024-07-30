extends Node2D

var shieldPrefab: PackedScene = preload("res://resourcers/items/shield.tscn")


func _on_area_2d_body_entered(body) -> void:
	var player: Player = body
	
	if player.isShieldActivated == true:
		for child in player.get_children():
			if child is Shield:
				var childShield: Shield = child
				var timerShield: Timer = childShield.get_child(2)
				timerShield.start()
				queue_free()
				return
	
	var shield = shieldPrefab.instantiate()
	shield.position = player.hitbox.position
	player.add_child(shield)
	GameManager.catchedItem.emit("shield_potion")
	queue_free()

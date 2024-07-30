extends AnimatedSprite2D

@onready var explosionArea: Area2D = $BigExplosionArea

var explosionDamage: int = 10
var didDamage: bool = false

func _process(_delta) -> void:
	if !self.is_playing():
		queue_free()

func doDamage(body) -> void:
	if body is Enemy:
			body.takeDamage(explosionDamage)
	elif body is Player:
		GameManager.playerTakeDamage.emit(explosionDamage)


func _on_big_explosion_area_body_entered(body):
	if self.frame > 3: return
	
	doDamage(body)

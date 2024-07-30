extends AnimatedSprite2D

@onready var explosionArea: Area2D = $Area2D

var explosionDamage: int = 5


func _process(_delta) -> void:
	if !self.is_playing():
		queue_free()


func _on_area_2d_body_entered(_body):
	if self.frame < 4:
		GameManager.playerTakeDamage.emit(explosionDamage)

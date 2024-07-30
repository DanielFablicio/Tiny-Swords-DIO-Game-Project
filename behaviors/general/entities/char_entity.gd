#classe base para todos os tipos de criaturas do tipo CharacterBody2D
#Obs: Acho que Composição seria melhor que herança, mas eu ainda não consigo
#"ver" exatamente o que acontece usando esse princípio

class_name CharEntity
extends CharacterBody2D

@export_category("General")
@export var maxHealth: int = 100
@export var maxSpeed: float = 4

@onready var health: int = maxHealth
@onready var speed: float = maxSpeed

@onready var sprite: AnimatedSprite2D = $Sprite


func takeDamage(amount: int) -> void:
	health -= amount
	
	if health <= 0:
		die()


func die():
	pass


func flipSprite(vectorX: float, sprite_: AnimatedSprite2D) -> void:
	if vectorX < 0:
		sprite_.flip_h = true
	elif vectorX > 0:
		sprite_.flip_h = false


func blink(color: Color, sprite_: AnimatedSprite2D) -> void:
	sprite_.modulate = color
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(sprite_, "modulate", Color.WHITE, 0.3)

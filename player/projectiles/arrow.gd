class_name Arrow
extends Node2D


@onready var arrowCollision: Area2D = $ArrowColission


var whichAttackType: StringName

var attackType: Dictionary = {
	"light": {
		"damage": 4,
		"speed": 2.1
	},
	"heavy": {
		"damage": 9,
		"speed": 3.0
	}
}

var arrowDamage: int = 4
var arrowSpeed: float

var arrowRotation: float = 0
var direction: Vector2 = Vector2.RIGHT



signal arrow_rotation(angle: float)

func _ready() -> void:
	setAtributes()
	rotation_degrees = arrowRotation
	arrowCollision.rotation_degrees = -rotation_degrees
	
	if rotation_degrees == 90:
		arrowCollision.scale *= Vector2(1, 0.1)
	
	arrow_rotation.emit(arrowRotation)
	


func _physics_process(_delta) -> void:
	var velocity: Vector2 = direction.normalized() * arrowSpeed * 10
	position += velocity


func setAtributes() -> void:
	arrowDamage = attackType[whichAttackType]["damage"]
	arrowSpeed = attackType[whichAttackType]["speed"]


func _on_arrow_timer_timeout():
	queue_free()


func _on_arrow_colission_body_entered(body: Enemy):
	
	
	if arrowCollision.global_position.y < body.damageMarker.global_position.y - 15:
		return
	
	var perfuration: int = body.health
	if arrowDamage <= 0:
		queue_free()
		return
	body.takeDamage(arrowDamage)
	arrowDamage = arrowDamage - perfuration
	
	if arrowDamage <= 0:
		queue_free()

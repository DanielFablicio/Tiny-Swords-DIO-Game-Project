class_name Arrow
extends Node2D


var whichAttackType: StringName

var attackType: Dictionary = {
	"light": {
		"damage": 2,
		"speed": 2.1
	},
	"heavy": {
		"damage": 3,
		"speed": 3.0
	}
}

var arrowDamage: int
var arrowSpeed: float

var arrowRotation: float = 0
var direction: Vector2 = Vector2.RIGHT

var perfurationCounter: int = 0

signal arrow_rotation(angle: float)

func _ready() -> void:
	setAtributes()
	self.rotation_degrees = arrowRotation
	self.arrow_rotation.emit(arrowRotation)


func _physics_process(_delta) -> void:
	var velocity: Vector2 = direction.normalized() * arrowSpeed * 10
	position += velocity


func _on_arrow_colission_area_entered(area) -> void:
	var enemy: Enemy = area.get_parent()
	enemy.takeDamage(arrowDamage)
	
	if whichAttackType == "heavy":
		perfurationCounter += 1
	
	if whichAttackType == "light" || perfurationCounter == 3:
		perfurationCounter = 0
		queue_free()


func setAtributes() -> void:
	arrowDamage = attackType[whichAttackType]["damage"]
	arrowSpeed = attackType[whichAttackType]["speed"]


func _on_arrow_timer_timeout():
	queue_free()

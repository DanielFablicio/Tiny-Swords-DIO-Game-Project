class_name FollowPlayer
extends Node

@onready var enemy: Enemy = get_parent()
var distanceVector: Vector2
var waitToActualize: bool = true

func _physics_process(_delta):
	if GameManager.playerDied || !GameManager.selectedPlayer: return
	
	waitToActualize = !waitToActualize
	if waitToActualize: return
	
	if !enemy.doingAttack:
		move()

func move():
	distanceVector = GameManager.playerPosition - enemy.position
	var targetVelocity: Vector2 = distanceVector.normalized() * enemy.speed * 100 * 2
	enemy.velocity = enemy.velocity.lerp(targetVelocity, 0.4)
	enemy.move_and_slide()

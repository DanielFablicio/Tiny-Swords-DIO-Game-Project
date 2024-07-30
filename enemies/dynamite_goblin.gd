extends Enemy

@onready var raycast: RayCast2D = $RayCast2D
@onready var thrownPoint: Marker2D = $ThrowPoint
@onready var attackTimer: Timer = $AttackTimer

var xPositionThrowPoint: float
var attackCooldownTimeout = true
var dynamitePrefab: PackedScene = preload("res://enemies/projectiles/dynamite.tscn")


func addInstructionsToReady()-> void:
	keySprite = 2
	enemyType = EnemyType.RANGE
	xPositionThrowPoint = thrownPoint.position.x
	
func addInstructionsToProcess():
	rotateRaycast()
	setAttacking()
	flipMarker()


func flipMarker() -> void:
	if sprite.flip_h:
		thrownPoint.position.x = -1 * xPositionThrowPoint
	else:
		thrownPoint.position.x = xPositionThrowPoint


func rotateRaycast() -> void:
	var distance: Vector2 = GameManager.playerPosition - position
	
	var rotateAngle: float = raycast.target_position.angle_to(distance)
	raycast.rotation = rotateAngle


func setAttacking():
	if raycast.is_colliding() && attackCooldownTimeout:
		attacking = true
	else:
		attacking = false


func doAttackModel() -> void:
	throwDynamite()
	attackCooldownTimeout = false
	attackTimer.start()


func throwDynamite() -> void:
	var dynamite: Path2D = dynamitePrefab.instantiate()
	dynamite.curve.set_point_position(0, position - Vector2(0, 30))
	dynamite.curve.set_point_position(1, GameManager.playerPosition)
	get_parent().add_child(dynamite)


func _on_attack_timer_timeout():
	attackCooldownTimeout = true

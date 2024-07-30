extends Player

@onready var shootPoint: Marker2D = $ShootPoint
var arrowPrefab: PackedScene = preload("res://player/projectiles/arrow.tscn")


func modifyKeySprite():
	keySprite = 6


func getWhichAttackType() -> StringName:
	return ""


func getDiagAttack() -> StringName:
	var diagAttack: StringName = ""
	var xInput: float = abs(inputDirection.x)
	
	if xInput > 0.6 && xInput < 0.8:
		diagAttack = "diag"
	else:
		diagAttack = ""

	return diagAttack


func addInstructionsToGetAttackCD() -> void:
	if not getDiagAttack().is_empty() && not yAttack.is_empty():
		if sprite.flip_h:
			attackDirection += Vector2.LEFT
		else:
			attackDirection += Vector2.RIGHT


func addInstructionsToProcess() -> void:
	var invertShootPointX: float
	
	if !sprite.flip_h:
		invertShootPointX = -10
	else:
		invertShootPointX = 10
		
	if attackDirection == Vector2.UP:
		invertShootPointX *= -1
	
	shootPoint.position.x = invertShootPointX
	
	if whichAttackType == "heavy" && (sprite.frame > 2 && sprite.frame < 6):	
		sprite.speed_scale = 0.6
	else:
		sprite.speed_scale = 1.3

func doAttackModel():
	var arrowDirection: Vector2 = getAttackConstantDirection()
	var arrow: Arrow = arrowPrefab.instantiate()
	arrow.direction = arrowDirection
	arrow.position = shootPoint.global_position
	arrow.arrowRotation = rad_to_deg(Vector2(1, 0).angle_to(attackDirection))
	arrow.whichAttackType = whichAttackType
	
	get_parent().add_child(arrow)

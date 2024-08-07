extends Player





enum AttackType {LIGHT = 3, HEAVY = 7}
var attackType: Dictionary = {
	"light": AttackType.LIGHT, 
	"heavy": AttackType.HEAVY
	}

@onready var swordArea: Area2D = $SwordArea


func doAttackModel() -> void:
	var swordDamage: int = attackType[whichAttackType]
	dealDamage(swordDamage)


func dealDamage(damageAmount) -> void:
	var bodies: Array[Node2D] = swordArea.get_overlapping_bodies()
	
	for body: Enemy in bodies:
		if calculateDotProduct(body) > 0.4:
			body.takeDamage(damageAmount)


func calculateDotProduct(enemy: Enemy) -> float:
	var directionToEnemy: Vector2 = (enemy.position - position).normalized()
	return getAttackConstantDirection().dot(directionToEnemy)




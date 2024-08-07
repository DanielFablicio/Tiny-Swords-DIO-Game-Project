extends Enemy

func dealDamage(amount: int) -> void:
	GameManager.playerTakeDamage.emit(amount)

func doAttackModel() -> void:
	dealDamage(1)

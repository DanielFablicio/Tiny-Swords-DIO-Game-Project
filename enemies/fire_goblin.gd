extends Enemy


enum GoblinType {SMALL = 6, MEDIUM = 9, TALL = 12}
var goblinType: Dictionary = {
	"small": {
		"health": GoblinType.SMALL,
		"damage": 2,
		"scale": 1,
		"speed": 1.3,
		"chance": 0.5
		},
	"medium": {
		"health": GoblinType.MEDIUM,
		"damage": 4,
		"scale": 1.4,
		"speed": 0.8,
		"chance": 0.3
		},
	"tall": {
		"health": GoblinType.TALL,
		"damage": 6,
		"scale": 2,
		"speed": 0.6,
		"chance": 0.2
		}
	}

var attackDamage: int

func addInstructionsToReady() -> void:
	enemyType = EnemyType.MELEE
	keySprite = 3
	setCharacteristics()


func doAttackModel():
	dealDamage(attackDamage)


func dealDamage(amount) -> void:
	GameManager.playerTakeDamage.emit(amount)



func getRandomGoblinType() -> StringName:
	var maxChance: float = 1.0
	var rangeMax: float = maxChance
	var rangeMin: float 

	var needle: float =  1 - randf()
	var types: Array = goblinType.keys()
	
	for type: StringName in types:
		rangeMin = rangeMax - goblinType[type]["chance"]
		if needle > rangeMin && needle <= rangeMax:
			return type
		
		rangeMax = rangeMin

	return "small"


func setCharacteristics() -> void:
	var choice: StringName = getRandomGoblinType()
	
	health = goblinType[choice]["health"]
	attackDamage = goblinType[choice]["damage"]
	speed = goblinType[choice]["speed"]
	self.scale *= goblinType[choice]["scale"]
	
	

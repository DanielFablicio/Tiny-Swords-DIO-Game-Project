class_name Enemy
extends CharEntity

enum EnemyType {MELEE, RANGE}
enum Itens {MEAT, GOLDEN_MEAT, SHIELD_POTION}
var itensList: Dictionary = {
	Itens.MEAT: {
		"name": "meat",
		"chance": 0.6
	},
	Itens.GOLDEN_MEAT: {
		"name": "golden_meat",
		"chance": 0.025
	},
	Itens.SHIELD_POTION: {
		"name": "shield_potion",
		"chance": 0.375
	},
}
var itens: Array[PackedScene]

@onready var followPlayer: FollowPlayer = $FollowPlayer
@onready var damageMarker: Marker2D = $DamageMarker



var damageNumberPrefab: PackedScene = preload("res://ui/effects/damageNumber.tscn")
var deathSkullPrefab: PackedScene = preload("res://misc/death_skull.tscn")

var attacking: bool = false
var doingAttack: bool = false
var lastSpriteFrame: int = 0

var keySprite: int = 3
var enemyType: int



func _ready() -> void:
	set_collision_mask_value(5, true)
	for item: int in itensList:
		var itemPrefab: String = "res://resourcers/items/" + itensList[item]["name"] + ".tscn"
		itens.append(load(itemPrefab))
	
	addInstructionsToReady()

func _process(_delta) -> void:
	
	flipSprite(followPlayer.distanceVector.x, sprite)

	if attacking:
		attack()
	elif !doingAttack: 
		sprite.play("run")
	
	addInstructionsToProcess()


func attack() -> void:
	sprite.play("attack")
	doingAttack = true
	if sprite.frame == keySprite && sprite.frame != lastSpriteFrame:
		doAttackModel()
	lastSpriteFrame = sprite.frame


func doAttackModel() -> void:
	pass


func takeDamage(amount: int) -> void:
	health -= amount
	showDamageTaked(amount)
	blink(Color.RED, sprite)
	
	if health <= 0:
		die()


func showDamageTaked(amount: int) -> void:
	var damageNumber: Node2D = damageNumberPrefab.instantiate()
	damageNumber.position = damageMarker.global_position
	damageNumber.get_child(0).text = str(amount)
	get_parent().add_child(damageNumber)


func die() -> void:
	GameManager.enemiesKilleds += 1
	var deathSkull: AnimatedSprite2D = deathSkullPrefab.instantiate()
	deathSkull.position = position
	get_parent().add_child(deathSkull)
	
	self.call_deferred("dropItem")
	
	queue_free()


func dropItem() -> void:
	if randf() > 0.2: return
	var item: Node2D = itens[getRandomItem()].instantiate()
	item.position = position
	
	get_parent().add_child(item)


func getRandomItem() -> int:
	var maxChance: float = 1.0
	var rangeMax: float = maxChance
	var rangeMin: float 

	var needle: float =  1 - randf()
	
	for item: int in itensList:
		rangeMin = rangeMax - itensList[item]["chance"]
		if needle > rangeMin && needle <= rangeMax:
			return item
		
		rangeMax = rangeMin

	return Itens.MEAT


func addInstructionsToReady() -> void:
	pass


func addInstructionsToProcess() -> void:
	pass


func _on_sprite_animation_finished() -> void:
	doingAttack = false

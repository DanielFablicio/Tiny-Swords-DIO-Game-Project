#classe base para o player
class_name Player
extends CharEntity


enum PlayerClasses {KNIGHT, ARCHER}

var attackDirection: Vector2

var deathSprite: Sprite2D
@onready var healthBar: ProgressBar = $HealthBar
@onready var collision: CollisionShape2D = $Collision
@onready var hitbox: Area2D = $HitboxCollision
@onready var ritualMagicPrefab: PackedScene = preload("res://player/magics/ritual.tscn")

var ritualTimer: Timer = Timer.new()


var inputDirection: Vector2

var whichAttackType: StringName = ""
var yAttack: StringName = ""


var keySprite: int = 3
var lastSpriteFrame: int = 0

var isShieldActivated: bool = false

func _ready():
	deathSprite = Sprite2D.new()
	deathSprite.texture = load("res://addons/TinySwords/Deco/16.png")
	set_collision_mask_value(5, true) #perceber terreno
	modifyKeySprite()
	sprite.y_sort_enabled = true
	
	hitbox.body_entered.connect(_on_hitbox_collision_body_entered)
	hitbox.body_exited.connect(_on_hitbox_collision_body_exited)
	GameManager.playerTakeDamage.connect(_on_playerTakeDamage)
	
	
	healthBar.max_value = maxHealth
	
	setRitualTimer()
	add_child(ritualTimer)


func _process(_delta) -> void:
	if isAttacking():
		attack()
	else: playRunIdleAnimation()
	flipSprite(inputDirection.x, sprite)
	
	healthBar.value = health
	addInstructionsToProcess()


func _physics_process(_delta) -> void:
	inputDirection = Input.get_vector("Left", "Right", "Up", "Down")
	treatInputDeadzone()
	
	if !isAttacking():
		move()
	
	GameManager.playerPosition = position
	GameManager.globalPlayerPosition = global_position


func setRitualTimer() -> void:
	ritualTimer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	ritualTimer.wait_time = 20
	ritualTimer.autostart = true
	ritualTimer.one_shot = false
	ritualTimer.timeout.connect(createRitual)


func treatInputDeadzone() -> void:
	
	if abs(inputDirection.x) < 0.15:
		inputDirection.x = 0
	if abs(inputDirection.y) < 0.15:
		inputDirection.y = 0


func move() -> void:
	var targetVelocity: Vector2 = inputDirection * speed * 100 
	velocity = velocity.lerp(targetVelocity, 0.4)
	move_and_slide()


func playRunIdleAnimation() -> void:
	if inputDirection:
		sprite.play("run")
	else:
		sprite.play("idle")


#função de ataque vazia só pra ser sobrescrita pelos outros métodos
func attack() -> void:
	var yAttackPrefix: String = changeToPrefix(getYAttack())
	var whichAttackPrefix: String = changeToPrefix(getWhichAttackType())
	var diagAttackPrefix: String = changeToPrefix(getDiagAttack())
	
	var spriteToPlay: StringName = diagAttackPrefix + yAttackPrefix + whichAttackPrefix + "attack"
	if spriteToPlay == "diag_attack":
		spriteToPlay = "attack"
	sprite.play(spriteToPlay)
	
	if sprite.frame == keySprite && sprite.frame != lastSpriteFrame:
		doAttackModel()
	
	lastSpriteFrame = sprite.frame


#retorna se o personagem está atacando e qual o
#tipo de ataque realizado(fraco ou forte)
func isAttacking() -> bool:
	var returnValue: bool = true
	
	if Input.is_action_pressed("Light_Attack"):
		whichAttackType = "light"
	elif Input.is_action_pressed("Heavy_Attack"):
		whichAttackType = "heavy"
	else:
		returnValue = false
	
	return returnValue


func doAttackModel() -> void:
	pass


func _on_playerTakeDamage(amount: int) -> void:
	if isShieldActivated: return
	takeDamage(amount)
	print(amount, "  ", health)


func die():
	GameManager.playerDied = true
	GameManager.playerHasDied.emit()
	deathSprite.position = position
	get_parent().add_child(deathSprite)
	queue_free()


func _on_hitbox_collision_body_entered(enemy: Enemy) -> void:
	if enemy.enemyType == Enemy.EnemyType.RANGE: return
	enemy.attacking = true


func _on_hitbox_collision_body_exited(enemy: Enemy) -> void:
	if enemy.enemyType == Enemy.EnemyType.RANGE: return
	enemy.attacking = false


func createRitual() -> void:
	var ritual: Node2D = ritualMagicPrefab.instantiate()
	add_child(ritual)


#retorna o tipo de ataque vertical
func getYAttack() -> StringName:
	
	#Pega somentes os valores do input.y acima de um valor definido
	#para controlar melhor quando o ataque vertical deve ser considerado
	var yInput: float = inputDirection.y if abs(inputDirection.y) > 0.6 else 0.0 
	#var attackInputX: float = inputDirection.x if abs(inputDirection.x) > 0.7 else 0.0
	
	if yInput > 0:
		yAttack = "down"
	elif yInput < 0:
		yAttack = "up"
	else:
		yAttack = ""
	
	return yAttack


func getDiagAttack() -> StringName:
	return ""


func getWhichAttackType() -> StringName:
	return whichAttackType


func getAttackConstantDirection() -> Vector2:
	
	if yAttack == "up":
		attackDirection = Vector2.UP
	elif yAttack == "down":
		attackDirection = Vector2.DOWN
	elif sprite.flip_h:
		attackDirection = Vector2.LEFT
	else:
		attackDirection = Vector2.RIGHT
	
	
	addInstructionsToGetAttackCD()
	
	return attackDirection


func modifyKeySprite():
	pass


func addInstructionsToProcess():
	pass


func addInstructionsToGetAttackCD() -> void:
	pass


func changeToPrefix(name_: StringName) -> String:
	return name_ + "_" if !name_.is_empty() else ""

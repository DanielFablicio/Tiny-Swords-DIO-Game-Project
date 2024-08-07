extends Enemy

@onready var explosionTimer: Timer = $ExplodeTimer


var bigExplosionPrefab: PackedScene = preload("res://enemies/projectiles/big_explosion.tscn")

func _ready() -> void:
	set_collision_mask_value(5, true)
	enemyType = EnemyType.MELEE


func _process(_delta) -> void:
	if doingAttack: return
	flipSprite(followPlayer.distanceVector.x, sprite)

	if attacking:
		attack()
	else: 
		sprite.play("run")

func attack() -> void:
	
	var childs: Array[Node] = self.get_children()
	for child in childs:
		if child is CollisionObject2D or child is CollisionShape2D:
			child.queue_free()
	followPlayer.queue_free()
	doingAttack = true
	sprite.play("attack")
	explosionTimer.start()


func _on_explode_timer_timeout() -> void:
	var bigExplosion: AnimatedSprite2D = bigExplosionPrefab.instantiate()
	bigExplosion.position = self.position - Vector2(0,  28)
	get_parent().add_child(bigExplosion)
	queue_free()


func die() -> void:
	attack()

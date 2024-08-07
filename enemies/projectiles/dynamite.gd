extends Path2D

var followPath: PathFollow2D

var explosionPrefab: PackedScene = preload("res://enemies/projectiles/explosion.tscn")
var detectPlayer: bool = false


func _ready():
	followPath = $PathFollow2D
	


func _physics_process(_delta):
	var progressValue: float = 8.0
	if followPath.progress_ratio <= 0.5:
		progressValue *= 1.5 - (followPath.progress_ratio / 2)
	else:
		progressValue *= 1 - (followPath.progress_ratio / 8)
	
	followPath.progress += progressValue
	if followPath.progress_ratio == 1:
		explode()


func explode() -> void:
	var explosion: AnimatedSprite2D = explosionPrefab.instantiate()
	explosion.position = followPath.position
	get_parent().add_child(explosion)
	
	queue_free()


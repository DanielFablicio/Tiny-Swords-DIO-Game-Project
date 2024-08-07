extends Node2D


@onready var followPath: PathFollow2D = $Path2D/PathFollow2D

enum Enemies {FIRE_GOBLIN, BARREL_GOBLIN, DYNAMITE_GOBLIN, SHEEP}
var enemies: Array[PackedScene]
var enemiesList: Dictionary = {
	Enemies.FIRE_GOBLIN: {
		"name": "fire_goblin",
		"chance": 0.29
		},
	Enemies.BARREL_GOBLIN: {
		"name": "barrel_goblin",
		"chance": 0.01
		},
	Enemies.DYNAMITE_GOBLIN: {
		"name": "dynamite_goblin",
		"chance": 0.2
		},
	Enemies.SHEEP: {
		"name": "sheep",
		"chance": 0.5
		}
	}


@export var initialSpawnRate: float = 20.0
@export var spawnRatePerMinute: float = 20.0
@export var breakIntensity: float = 0.5
@export var waveFactor: float = 1.3

var interval: float = 1.1



func _ready() -> void:
	
	for enemy: int in enemiesList:
		var enemyPrefab: String = "res://enemies/" + enemiesList[enemy]["name"] + ".tscn"
		enemies.append(load(enemyPrefab))
	


func _process(delta: float) -> void:
	if GameManager.playerDied || !GameManager.selectedPlayer: return
	#print(GameManager.selectedPlayer)
	interval -= delta
	if interval >= 0: return
	
	var spawnRate: float = initialSpawnRate + 39*spawnRatePerMinute * (GameManager.timeElapsed / 60)
	var wave: float = sin( GameManager.timeElapsed * waveFactor) + 1
	
	interval = 60 / abs(spawnRate - 25*wave)
	if interval > 3.0:
		interval = 2.5
	elif interval < 0.1:
		interval = 0.1
	spawnEnemy()


func spawnEnemy() -> void:
	var point = getRandomPoint()
	if !isPositionValid(point): return
	
	var randomEnemy: int = getRandomEnemy()
	var enemy: Enemy = enemies[randomEnemy].instantiate()
	
	enemy.position = point
	get_parent().add_child(enemy)


func getRandomEnemy() -> int:
	var maxChance: float = 1.0
	var rangeMax: float = maxChance
	var rangeMin: float 

	var needle: float =  1 - randf()
	
	for enemy: int in enemiesList:
		rangeMin = rangeMax - enemiesList[enemy]["chance"]
		if needle > rangeMin && needle <= rangeMax:
			return enemy
		
		rangeMax = rangeMin

	return Enemies.SHEEP


func getRandomPoint() -> Vector2:
	followPath.progress_ratio = randf()
	return followPath.global_position


func isPositionValid(point: Vector2) -> bool:
	var world: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var parameters: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	parameters.collision_mask = 0b10010
	parameters.position = point
	
	#print(world.intersect_point(parameters, 1))
	if world.intersect_point(parameters, 1).is_empty():
		return true
	return false
	

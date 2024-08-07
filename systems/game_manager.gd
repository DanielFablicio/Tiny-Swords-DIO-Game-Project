extends Node

signal gameOver
signal playerTakeDamage(amount: int)
signal playerSelected(name: StringName)
signal playerHasDied()
signal catchedItem(item: StringName)
signal resetGame()

signal ritualCreated(time: float)

var playerDied: bool = false
var selectedPlayer: bool = false

var playerPosition: Vector2
var globalPlayerPosition: Vector2

var meatCounter: int = 0
var enemiesKilleds: int = 0

var timeElapsed: float = 0.0
var timeELapsedInSeconds: int = 0
var timeElapsedInMinutes: int = 0


func _ready():
	GameManager.resetGame.connect(reset)


func _process(delta) -> void:
	if playerDied || !selectedPlayer: return
	timeElapsed += delta
	
	timeELapsedInSeconds = floori(timeElapsed) % 60
	timeElapsedInMinutes = floori(timeElapsed / 60)


func reset():
	print("reset")
	playerDied = false
	selectedPlayer = false

	playerPosition = Vector2.ZERO
	globalPlayerPosition = Vector2.ZERO

	meatCounter = 0
	enemiesKilleds = 0
	
	timeElapsed = 0.0
	timeELapsedInSeconds = 0
	timeElapsedInMinutes = 0
	
	for connection in gameOver.get_connections():
		connection.callable.disconnect()
	
	get_tree().reload_current_scene()
	get_tree().paused = false

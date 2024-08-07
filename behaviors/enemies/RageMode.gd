extends Node

@onready var rageModeTimer: Timer
@onready var goblin: Enemy

var rageModeCooldown: float = 20.0
var rageFactor: float = 2



func _ready():
	goblin = get_parent()
	rageModeTimer = goblin.get_child(5)
	


func _process(delta):
	if GameManager.playerDied || !GameManager.selectedPlayer: return
	
	
	
	rageModeCooldown -= delta
	if rageModeCooldown > 0: return
	print("rageMode")
	activateRage()
	rageModeCooldown = 20.0 + rageModeTimer.wait_time

func activateRage() -> void:
	goblin.speed *= rageFactor
	goblin.sprite.speed_scale *= rageFactor
	goblin.sprite.self_modulate = Color.RED
	rageModeTimer.start()
	


func _on_rage_mode_timer_timeout():
	goblin.speed /= rageFactor
	goblin.sprite.speed_scale /= rageFactor
	goblin.sprite.self_modulate = Color.WHITE

extends HBoxContainer

@onready var ritualTimer: Timer = $RitualPanel/RitualTimer
@onready var ritualCooldownShape: TextureProgressBar = $RitualPanel/CooldownShape

func _ready():
	GameManager.ritualCreated.connect(activateRitualCooldown)
	GameManager.playerSelected.connect(startCooldown)


func _process(_delta):
	ritualCooldownShape.value = 100*(ritualTimer.time_left / ritualTimer.wait_time)


func activateRitualCooldown(time: float) -> void:
	ritualCooldownShape.visible = true
	ritualTimer.wait_time = time
	ritualTimer.start()


func startCooldown(_player: StringName) -> void:
	ritualTimer.start()


func _on_ritual_timer_timeout() -> void:
	ritualCooldownShape.visible = false

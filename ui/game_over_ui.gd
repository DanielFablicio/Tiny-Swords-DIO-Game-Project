extends Control

func _ready():
	GameManager.playerHasDied.connect(play)


func _on_reset_timer_timeout():
	GameManager.resetGame.emit()


func play() -> void:
	var minutes: int = GameManager.timeElapsedInMinutes
	var seconds: int = GameManager.timeELapsedInSeconds
	%TimeSurvived.text = "%02d:%02d" % [minutes, seconds]
	%EnemiesKilleds.text = str(GameManager.enemiesKilleds)
	
	self.visible = true
	$AnimationPlayer.play("default")
	$ResetTimer.start()

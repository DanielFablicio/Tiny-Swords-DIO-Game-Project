class_name Shield
extends Node2D


@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

var player: Player
var isPlayingOnReverse: bool = false

func _ready():
	player = get_parent()
	player.isShieldActivated = true

func _on_shield_timer_timeout():
	player.isShieldActivated = false
	animationPlayer.speed_scale = 3
	animationPlayer.play_backwards("default")
	isPlayingOnReverse = true

func _on_animation_player_animation_finished(_anim_name):
	if !isPlayingOnReverse: return
	queue_free()

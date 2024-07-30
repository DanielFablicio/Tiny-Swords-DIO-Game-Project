extends Control

@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready():
	%Resume.pressed.connect(resume)
	%Quit.pressed.connect(quit)

func resume() -> void:
	#print("resume")
	get_tree().paused = false
	animation.play_backwards("default")
	self.visible = false


func pause() -> void:
	#print("pause")
	get_tree().paused = true
	self.visible = true
	animation.play("default")
	


func quit() -> void:
	get_tree().quit()


func _process(_delta):

	if Input.is_action_just_pressed("Esc") && !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("Esc") && get_tree().paused:
		resume()

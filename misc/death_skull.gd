extends AnimatedSprite2D

func _process(_delta):
	removeAfterFinished()


func removeAfterFinished():
	if !self.is_playing():
		queue_free()

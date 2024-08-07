extends AudioStreamPlayer

func _ready():
	GameManager.playerSelected.connect(func(_x): play())

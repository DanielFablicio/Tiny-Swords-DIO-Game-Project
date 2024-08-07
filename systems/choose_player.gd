extends Node2D

var knight: PackedScene = preload("res://player/classes/player_knight.tscn")
var archer: PackedScene = preload("res://player/classes/player_archer.tscn")


func _ready() -> void:
	GameManager.playerSelected.connect(instantiatePlayer)

func instantiatePlayer(name_: StringName) -> void:
	var player: Player
	match name_:
		"knight":
			player = knight.instantiate()
			
		"archer":
			player = archer.instantiate()
	
	player.position = $SpawnPoint.position
	addRemoteTransformers(player)
	add_child(player)
	
	
	GameManager.selectedPlayer = true


func addRemoteTransformers(player: Player) -> void:
	var cameraRemote: RemoteTransform2D = RemoteTransform2D.new()
	var mobSpawnerRemote: RemoteTransform2D = RemoteTransform2D.new()
	
	cameraRemote.update_scale = false
	cameraRemote.update_rotation = false
	
	mobSpawnerRemote.update_scale = false
	mobSpawnerRemote.update_rotation = false
	
	cameraRemote.remote_path = $Camera2D.get_path()
	mobSpawnerRemote.remote_path = $MobSpawner.get_path()
	
	player.add_child(cameraRemote)
	player.add_child(mobSpawnerRemote)

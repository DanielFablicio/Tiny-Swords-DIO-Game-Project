extends Control

var selected: bool = false

func _on_knight_button_pressed() -> void:
	if selected: return
	GameManager.playerSelected.emit("knight")
	GameManager.selectedPlayer = true
	self.visible = false
	selected = true


func _on_archer_button_pressed() -> void:
	if selected: return
	GameManager.playerSelected.emit("archer")
	GameManager.selectedPlayer = true
	self.visible = false
	selected = true

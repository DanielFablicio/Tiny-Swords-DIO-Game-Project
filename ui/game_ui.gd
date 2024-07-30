extends Control

@onready var timerLabel: Label = $Timer
@onready var meatLabel: Label = $ItemCounter/MeatCounter


func _ready() -> void:
	GameManager.catchedItem.connect(countMeat)


func _process(_delta) -> void:
	var minutes: int = GameManager.timeElapsedInMinutes
	var seconds: int = GameManager.timeELapsedInSeconds
	timerLabel.text = "%02d:%02d" % [minutes, seconds]
	
	meatLabel.text = str(GameManager.meatCounter)


func countMeat(item: StringName) -> void:
	if item != "meat": return
	
	GameManager.meatCounter += 1

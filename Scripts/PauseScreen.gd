extends Control

signal redoLevel(level)
@onready var bg : ColorRect = $ColorRect
func _ready() -> void:
	get_tree().paused = false
	hide()
	Handler.loss.connect(pause)
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause") && !Handler.isLoss:
		pause()
	elif event.is_action_pressed("Pause") && Handler.isLoss:
		redo()
	elif get_tree().paused && event.is_action_pressed("Dash"):
		redo()

func pause():
	get_tree().paused = !get_tree().paused
	visible = !visible


func redo():
	get_tree().paused = false
	hide()
	redoLevel.emit(Handler.level)

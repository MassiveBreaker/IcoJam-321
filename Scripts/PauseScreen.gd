extends Control

signal redoLevel(level)
@onready var bg : ColorRect = $ColorRect


@onready var resolutionShow : Control = $Resolutions


var resolutions : Dictionary = {"1024x1024" : Vector2i(1024,1024),
								"512x512" : Vector2i(512,512)}

func _ready() -> void:
	addResolutions()
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


func addResolutions():
	for r in resolutions:
		$Resolutions/OptionButton.add_item(r)


func _on_option_button_item_selected(index: int) -> void:
	var size = resolutions.get($Resolutions/OptionButton.get_item_text(index))
	DisplayServer.window_set_size(size)
	DisplayServer.window_set_position(DisplayServer.screen_get_size()/2 - size/2)
	pass # Replace with function body.

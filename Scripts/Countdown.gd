extends Control

@onready var label = $HBoxContainer/Label
@onready var Three : Timer = $Timers/Three
@onready var Two : Timer = $Timers/Two
@onready var One : Timer = $Timers/One
@onready var littleTimer : Timer = $Timers/LittleTimer
func _ready() -> void:
	label.text = "3\n2\n1\n..."
	label.visible_characters = 0
	await get_tree().create_timer(.3).timeout
	Three.start()
	$Sound/Three.play()
	label.visible_characters = 1

func _process(_delta: float) -> void:
	if Handler.timeSlow:
		$Sound/Three.pitch_scale = .75
		$Sound/Two.pitch_scale = .75
		$Sound/One.pitch_scale = .75
	elif !Handler.timeSlow:
		$Sound/Three.pitch_scale = 1.0
		$Sound/Two.pitch_scale = 1.0
		$Sound/One.pitch_scale = 1.0

func _on_three_timeout() -> void:
	label.visible_characters = 3
	Two.start()
	$Sound/Two.play()
	pass # Replace with function body.


func _on_two_timeout() -> void:
	label.visible_characters = 5
	One.start()
	$Sound/One.play()
	pass # Replace with function body.


func _on_one_timeout() -> void:
	label.visible_characters = 7
	littleTimer.start()
	pass # Replace with function body.


func _on_little_timer_timeout() -> void:
	if label.visible_characters < 9:
		label.visible_characters +=1
		littleTimer.start()
		return
	Handler.loss.emit()
	Handler.isLoss = true
	pass # Replace with function body.

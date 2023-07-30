extends Control

signal level_changed(level)
signal loss(level)
var timeSlow : bool
var level : int
var isLoss : bool
func _process(delta: float) -> void:
	if timeSlow:
		Engine.time_scale = .5
	else:
		Engine.time_scale = 1


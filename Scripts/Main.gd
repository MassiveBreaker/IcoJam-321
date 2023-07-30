extends Node2D
##Variables
#-------------------------------
@onready var levels : Node2D = $Levels
@export var levelContainer : Array[PackedScene]


#-------------------------------

func _ready() -> void:
	Handler.level_changed.connect(_level_changed)
	Handler.isLoss = false

func _level_changed(level):
	if(level == 1):
		$Placeholder.queue_free()
	pickLevel(level)
	pass

func pickLevel(level):
	Handler.isLoss = false
	if level == 0:
		get_tree().reload_current_scene()
		return
	if $Levels.get_child_count() > 0: $Levels.get_child(0).queue_free()
	var newLevel = levelContainer[level].instantiate()
	newLevel.position = Vector2.ZERO
	#get_node("Levels").add_child(newLevel)
	get_node("Levels").call_deferred("add_child",newLevel)

extends Area2D

func _on_body_entered(body: Node2D) -> void:
	Handler.level += 1
	Handler.level_changed.emit(Handler.level)
	pass # Replace with function body.

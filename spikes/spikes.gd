extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		@warning_ignore(return_value_discarded)
		get_tree().reload_current_scene()

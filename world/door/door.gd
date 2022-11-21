extends Area2D


@export_file("*.tscn") var target_level_path := ""


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	get_tree().change_scene_to_file(target_level_path)

extends CanvasLayer


signal transition_finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func play_exit_transition() -> void:
	animation_player.play("exit_level")


func play_enter_transition() -> void:
	animation_player.play("enter_level")


func _on_animation_player_animation_finished() -> void:
	transition_finished.emit()

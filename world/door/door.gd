extends Area2D


@export_file("*.tscn") var target_level_path := ""

var player: Player

@onready var _scene_tree := get_tree()


func _process(delta: float) -> void:
	if player == null or not player.is_on_floor():
		return
	
	if Input.is_action_just_pressed("ui_down"):
		go_to_next_room()


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	player = body as Player


func _on_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
	player = null


func go_to_next_room() -> void:
	Transitions.play_exit_transition()
	_scene_tree.paused = true
	await Transitions.transition_finished
	Transitions.play_enter_transition()
	_scene_tree.paused = false
	_scene_tree.change_scene_to_file(target_level_path)

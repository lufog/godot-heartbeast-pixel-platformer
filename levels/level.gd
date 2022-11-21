extends Node2D


const PLAYER_SCENE: PackedScene = preload("res://player/player.tscn")

var player_spawn_position: Vector2

@onready var camera: Camera2D = $Camera
@onready var player: Player = $Player
@onready var respawn_timer: Timer = $RespawnTimer

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.LIGHT_BLUE)
	player_spawn_position = player.position
	player.connect_camera(camera)
	Events.player_died.connect(_on_player_died)
	Events.hit_checkpoint.connect(_on_hit_checkpoint)


func _on_player_died() -> void:
	player = PLAYER_SCENE.instantiate()
	respawn_timer.start()
	await respawn_timer.timeout
	add_child(player)
	player.position = player_spawn_position
	player.connect_camera(camera)


func _on_hit_checkpoint(checkpoint_position) -> void:
	player_spawn_position = checkpoint_position

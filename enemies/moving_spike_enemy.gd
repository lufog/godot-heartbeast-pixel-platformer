@tool
extends Path2D


enum AnimationTypes { LOOP, BOUNCE }

@export var animation_type := AnimationTypes.LOOP:
	get:
		return animation_type
	set(value):
		if animation_player == null:
			await ready
		animation_type = value
		update_animations()
		
@export var speed := 1.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	update_animations()


func update_animations() -> void:
	animation_player.playback_speed = speed
	match animation_type:
		AnimationTypes.LOOP:
			animation_player.play("move_along_path_loop")
		AnimationTypes.BOUNCE:
			animation_player.play("move_along_path_bounce")

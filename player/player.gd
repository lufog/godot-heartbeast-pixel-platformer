class_name Player extends CharacterBody2D

enum { MOVE, CLIMB }

@export var move_data: PlayerMovementData

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var state := MOVE
var double_jump := 1
var buffered_jump := false
var coyote_jump := false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var ladder_check_ray_cast: RayCast2D = $LadderCheckRayCast
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var coyote_jump_timer: Timer = $CoyoteJumpTimer
@onready var camera_transform: RemoteTransform2D = $CameraTransform


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	match state:
		MOVE:
			move_state(delta, direction.x)
		
		CLIMB:
			climb_state(delta, direction)


func move_state(delta: float, direction_x: float) -> void:
	if is_on_ladder() and Input.is_action_just_pressed("ui_up"):
		state = CLIMB
	
	if not is_on_floor():
		# Add the gravity.
		velocity.y += gravity * delta
		animated_sprite.play("jump")
	elif velocity.x != 0:
		animated_sprite.flip_h = velocity.x > 0
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
	
	if is_on_floor():
		double_jump = move_data.double_jump_count
		
	if is_on_floor() or coyote_jump:
		if Input.is_action_just_pressed("ui_up") or buffered_jump:
			velocity.y = move_data.jump_velocity
			SoundPlayer.play_sound(SoundPlayer.JUMP_AUDIO_STREAM)
			buffered_jump = false
	else:
		if Input.is_action_just_released("ui_up") and velocity.y < move_data.half_jump_velocity:
			velocity.y = move_data.half_jump_velocity
		
		if Input.is_action_just_pressed("ui_up"):
			buffered_jump = true
			jump_buffer_timer.start()
		
		if Input.is_action_just_pressed("ui_up") and double_jump > 0:
			velocity.y = move_data.jump_velocity
			SoundPlayer.play_sound(SoundPlayer.JUMP_AUDIO_STREAM)
			double_jump -= 1
	
	if direction_x:
		velocity.x = move_toward(velocity.x, direction_x * move_data.max_speed, move_data.acceleration) 
	else:
		velocity.x = move_toward(velocity.x, 0, move_data.friction)
	
	var was_in_air := not is_on_floor()
	move_and_slide()
	var on_floor := is_on_floor()
	
	if on_floor and was_in_air:
		animated_sprite.play("run")
		animated_sprite.frame = 1
	
	var just_left_ground := not was_in_air and not on_floor
	if just_left_ground and velocity.y >= 0:
		coyote_jump = true
		coyote_jump_timer.start()


func climb_state(_delta: float, direction: Vector2) -> void:
	if not is_on_ladder():
		state = MOVE
	
	velocity = direction * move_data.climb_speed
	
	if direction.length() != 0:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
	
	move_and_slide()


func connect_camera(camera: Camera2D) -> void:
	camera_transform.remote_path = camera.get_path()
	camera_transform.force_update_cache()


func die() -> void:
	SoundPlayer.play_sound(SoundPlayer.HURT_AUDIO_STREAM)
	Events.player_died.emit()
	queue_free()


func is_on_ladder() -> bool:
	if not ladder_check_ray_cast.is_colliding():
		return false
	
	var collider := ladder_check_ray_cast.get_collider()
	return collider is Ladder


func _on_jump_buffer_timer_timeout() -> void:
	buffered_jump = false


func _on_coyote_jump_timer_timeout() -> void:
	coyote_jump = false

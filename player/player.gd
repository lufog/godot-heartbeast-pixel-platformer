class_name Player extends CharacterBody2D

enum { MOVE, CLIMB }

@export var move_data: PlayerMovementData

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var state := MOVE

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var ladder_check_ray_cast: RayCast2D = $LadderCheckRayCast


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	match state:
		MOVE:
			move_state(delta, direction.x)
		
		CLIMB:
			climb_state(delta, direction)


func move_state(delta: float, direction_x: int) -> void:
	if is_on_ladder() and Input.is_action_pressed("ui_up"):
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
	
	# Handle Jump.
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			velocity.y = move_data.jump_velocity
	else:
		if Input.is_action_just_released("ui_up") and velocity.y < move_data.half_jump_velocity:
			velocity.y = move_data.half_jump_velocity
	
	if direction_x:
		velocity.x = move_toward(velocity.x, direction_x * move_data.max_speed, move_data.acceleration) 
	else:
		velocity.x = move_toward(velocity.x, 0, move_data.friction)
	
	var was_in_air := not is_on_floor()
	
	@warning_ignore(return_value_discarded)
	move_and_slide()
	
	if is_on_floor() and was_in_air:
		animated_sprite.play("run")
		animated_sprite.frame = 1


func climb_state(delta: float, direction: Vector2) -> void:
	if not is_on_ladder():
		state = MOVE
	
	velocity = direction * 50
	
	if direction.length() != 0:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
	
	move_and_slide()


func is_on_ladder() -> bool:
	if not ladder_check_ray_cast.is_colliding():
		return false
	
	var collider := ladder_check_ray_cast.get_collider()
	return collider is Ladder

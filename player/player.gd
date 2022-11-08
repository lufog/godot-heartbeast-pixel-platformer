extends CharacterBody2D


@export var jump_velocity := -220.0
@export var half_jump_velocity := -110
@export var max_speed := 50.0
@export var acceleration := 10.0
@export var friction := 10.0

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite


func _physics_process(delta: float) -> void:
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
			velocity.y = jump_velocity
	else:
		if Input.is_action_just_released("ui_up") and velocity.y < half_jump_velocity:
			velocity.y = half_jump_velocity
	
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * max_speed, acceleration) 
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
	
	var was_in_air := not is_on_floor()
	
	@warning_ignore(return_value_discarded)
	move_and_slide()
	
	if is_on_floor() and was_in_air:
		animated_sprite.play("run")
		animated_sprite.frame = 1

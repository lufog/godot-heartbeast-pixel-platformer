extends CharacterBody2D


@export var jump_velocity := -200.0
@export var half_jump_velocity := -100
@export var max_speed := 50.0
@export var acceleration := 10.0
@export var friction := 10.0

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

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

	@warning_ignore(return_value_discarded)
	move_and_slide()

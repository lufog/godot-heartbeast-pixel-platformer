extends CharacterBody2D


const SPEED = 25.0

var direction := 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var ledge_check_ray_cast: RayCast2D = $LedgeCheckRayCast


func _physics_process(delta: float) -> void:
	var found_ledge := not ledge_check_ray_cast.is_colliding()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = direction * SPEED
	
	move_and_slide()
	
	if is_on_wall() or found_ledge:
		scale.x *= -1
		direction *= -1
#		ledge_check_ray_cast.position.x = -ledge_check_ray_cast.position.x
#		direction *= -1

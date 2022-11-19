extends Node2D


enum States { HOVER, FALL, LAND, RISE }

@export var fall_speed := 80.0
@export var rise_speed := 20.0

var state := States.HOVER

@onready var start_position := global_position

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var particles: GPUParticles2D = $Particles
@onready var ray_cast: RayCast2D = $RayCast
@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.start()


func _physics_process(delta: float) -> void:
	match state:
		States.HOVER:
			_hover_state()
		States.FALL:
			_fall_state(delta)
		States.LAND:
			_land_state()
		States.RISE:
			_rise_state(delta)


func _hover_state() -> void:
	if timer.is_stopped():
		state = States.FALL


func _fall_state(delta: float) -> void:
	if ray_cast.is_colliding():
		var collision_point := ray_cast.get_collision_point()
		position.y = collision_point.y
		state = States.LAND
		particles.emitting = true
		timer.start()
		return
	
	animated_sprite.play("falling")
	position.y += fall_speed * delta


func _land_state() -> void:
	if timer.is_stopped():
		state = States.RISE


func _rise_state(delta: float) -> void:
	if position.y == start_position.y:
		state = States.HOVER
		timer.start()
		return
	
	animated_sprite.play("rising")
	position.y = move_toward(position.y, start_position.y, rise_speed * delta)

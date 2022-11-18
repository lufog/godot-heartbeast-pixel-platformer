extends Area2D


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

var active := false


func _on_body_entered(body: Node2D) -> void:
	var player := body as Player
	if player == null or active:
		return
	
	active = true
	animated_sprite.play("checked")
	Events.hit_checkpoint.emit(position)

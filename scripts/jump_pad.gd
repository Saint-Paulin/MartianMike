extends Area2D

@export var jump_force = 1250

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		$AnimatedSprite2D.play("Jump")
		body.jump(jump_force)

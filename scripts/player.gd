extends CharacterBody2D
class_name Player

var move_speed : float = 700
var gravity : float = 3000
var jump_force : float = 5000

@onready var animated_sprite = $AnimatedSprite2D
#@onready var stateMachine = animated_sprite.get("parameters/playback")
var active = true

func _physics_process(delta: float) -> void:
	
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 500:
			velocity.y = 500
	var input_direction
	if active == true:
		if Input.is_action_just_pressed("jump") && is_on_floor():
			jump(jump_force)
		input_direction = Input.get_axis("move_left", "move_right")
		velocity.x = input_direction * move_speed
	
	if input_direction != 0:
		animated_sprite.flip_h = (input_direction == -1)
	
	
	move_and_slide()
	update_animations(input_direction)

func update_animations(direction):
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("Run")
	else:
		if velocity.y < 0:
			animated_sprite.play("Jump")
		else:
			animated_sprite.play("Fall")

func jump(force):
	velocity.y = -force

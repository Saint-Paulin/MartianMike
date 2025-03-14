extends Node2D

#@onready var player = $Player
var player = null
@onready var exit = $Exit
@onready var death_zone = $Deathzone
@onready var hud = $UILayer/HUD
@onready var win_screen = $UILayer/WinScreen

@export var next_level : PackedScene
@export var is_final_level : bool = false
@export var level_time = 5

var timer_node = null
var time_left
var win = false

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player != null:
		player.global_position = $Start.get_spawn_pos()
	var traps = get_tree().get_nodes_in_group("traps")
	for t in traps:
		t.connect("touched_player", _on_trap_touched_player)
	exit.body_entered.connect(_on_exit_body_entered)
	death_zone.connect("body_entered", _on_deathzone_body_entered)
	
	time_left = level_time
	hud.set_time_label(time_left)
	
	timer_node = Timer.new()
	timer_node.name = "LevelTimer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	timer_node.start()

func _on_level_timer_timeout():
	if win == false:
		time_left -= 1
		hud.set_time_label(time_left)
		if time_left < 0:
			reset_player()
			time_left = level_time
			hud.set_time_label(time_left)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func _on_deathzone_body_entered(body: Node2D) -> void:
	body.velocity = Vector2.ZERO
	body.global_position = $Start.get_spawn_pos()


func _on_trap_touched_player() -> void:
	reset_player()

func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = $Start.get_spawn_pos()

func _on_exit_body_entered(body):
	if body is Player:
		if is_final_level || next_level != null:
			exit.animate()
			player.active = false
			win = true
			await get_tree().create_timer(1.5).timeout
			if is_final_level:
				win_screen.visible = true
			else:
				get_tree().change_scene_to_packed(next_level)

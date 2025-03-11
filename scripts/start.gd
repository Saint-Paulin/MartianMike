extends StaticBody2D

func get_spawn_pos():
	return $SpawnPosition.global_position

func _ready() -> void:
	print(get_spawn_pos())

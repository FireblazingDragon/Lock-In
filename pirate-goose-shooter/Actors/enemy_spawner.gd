extends Node2D
@export var enemy : PackedScene


func _on_spawn_timer_timeout() -> void:
	var spawned_enemy = enemy.instantiate()
	spawned_enemy.global_position = global_position
	get_parent().add_child(spawned_enemy)

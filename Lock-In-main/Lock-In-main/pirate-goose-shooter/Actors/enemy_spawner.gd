extends Node2D
@export var enemy1 : PackedScene
@export var enemy2 : PackedScene
@export var enemy3 : PackedScene
var enemies_spawned := 0
var total_enemies := 0
var wave = 0

#Spawns enemies
func spawn(enemies, wave_num):
	var spawned_enemy
	if wave_num == 1:
		spawned_enemy = enemy1.instantiate()
	elif wave_num == 2:
		var random = randi_range(0, 1)
		if random == 0:
			spawned_enemy = enemy1.instantiate()
		else:
			spawned_enemy = enemy2.instantiate()
	elif wave_num == 3:
		var random = randi_range(0, 2)
		if random == 0:
			spawned_enemy = enemy1.instantiate()
		elif random == 1:
			spawned_enemy = enemy2.instantiate()
		else:
			spawned_enemy = enemy3.instantiate()
	spawned_enemy.global_position = global_position
	get_parent().add_child(spawned_enemy)
	enemies_spawned += 1
	total_enemies = enemies
	wave = wave_num
	if enemies_spawned < enemies:
		$SpawnTimer.start()





func _on_spawn_timer_timeout() -> void:
	spawn(total_enemies, wave)

extends Node2D
@export var enemy_spawners : Array[Node2D]
var current_wave = 0

func _ready() -> void:
	current_wave = 1
	summon_wave()

func _on_wave_timer_timeout() -> void:
	if current_wave < 3:
		current_wave += 1
		summon_wave()

func summon_wave():
	#Summons slightly random amount of enemies each time
	var enemy_amount = randi_range(2 + current_wave * 3, 3 + current_wave * 4)
	for i in enemy_spawners:
		i.spawn(enemy_amount, current_wave)

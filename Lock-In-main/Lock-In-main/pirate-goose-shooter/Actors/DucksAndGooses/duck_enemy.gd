extends Actor
@onready var level = get_tree().get_root()
@onready var projectile = load("res://Actors/Bullets/enemy_bullet.tscn")
var can_shoot = true
var direction_facing = 1



func _physics_process(_delta: float) -> void:
	move_and_slide()
	#Moves enemy toward player
	var dir_to_player = (Global.player_position-global_position).normalized()
	
	velocity = dir_to_player * 70
	
	#Sets enemy direction
	if velocity.x > 5:
		direction_facing = 1
	elif velocity.x < -5:
		direction_facing = -1
	
	#Animations
	if direction_facing == 1:
		$AnimatedSprite2D.play("MoveRight")
	else:
		$AnimatedSprite2D.play("MoveLeft")
	
	#Shoots if player is near
	if $PlayerDetector.get_overlapping_bodies() and can_shoot:
		can_shoot = false
		var instance = projectile.instantiate()
		instance.dir = get_angle_to(Global.player_position)
		instance.spawnPos = global_position
		instance.spawnRot = get_angle_to(Global.player_position)
		level.add_child.call_deferred(instance)
		$Timer.start()


#Allows enemy to shoot again after timer ends
func _on_timer_timeout() -> void:
	can_shoot = true


func take_damage():
	health -= 1
	$GeneralHealthBar.update()
	if health == 0:
		queue_free()

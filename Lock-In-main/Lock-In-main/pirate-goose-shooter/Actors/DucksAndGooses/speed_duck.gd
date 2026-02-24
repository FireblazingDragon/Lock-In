extends Actor
var direction_facing  = 1
var can_attack = true
var diving = false

func _physics_process(_delta: float) -> void:
	move_and_slide()
	
	if can_attack == true:
		#Moves enemy toward player
		var dir_to_player = (Global.player_position-global_position).normalized()
		
		velocity = dir_to_player * 110
		
		$AnimatedSprite2D.play("Walk")
		
		if $PlayerDetector.get_overlapping_bodies():
			dive()
			can_attack = false
	
	#Stops enemy from moving while stunned
	if diving == false and can_attack == false:
		velocity = Vector2(0,0)
		$AnimatedSprite2D.play("Crash")
		
		
	
	#Sets enemy direction
	if velocity.x > 5:
		direction_facing = 1
		$AnimatedSprite2D.flip_h = true
	elif velocity.x < -5:
		direction_facing = -1
		$AnimatedSprite2D.flip_h = false

func dive():
	$PreDive.start()
	diving = true
	$AnimatedSprite2D.play("Dive")
	
	
func take_damage():
	health -= 1
	$GeneralHealthBar.update()
	if health == 0:
		queue_free()


func _on_pre_dive_timeout() -> void:
	var dir_to_player = (Global.player_position-global_position).normalized()
	velocity = dir_to_player * 500
	$DiveTime.start()


func _on_dive_time_timeout() -> void:
	diving = false
	$StunTime.start()


func _on_stun_time_timeout() -> void:
	can_attack = true


func _on_hitbox_body_entered(body: Node2D) -> void:
	body.take_damage()
	_on_dive_time_timeout()

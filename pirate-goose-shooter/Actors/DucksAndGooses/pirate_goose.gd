extends Actor
@export var speed = 100
@export var max_ammo = 6
@onready var projectile = load("res://Actors/Bullets/player_bullet.tscn")
@onready var level = get_tree().get_root()
var vertical_direction = 0
var horizontal_direction = 0
var last_horz_dir = 1
var projectile_reloaded = true
var dashing = false
var dash_reset = true
var invincible_frames = false
var ammo_rn = max_ammo


func _physics_process(_delta: float) -> void:
	#Movement
	move_and_slide()
	if dashing == false:
		if Input.is_action_just_pressed("Up"):
			vertical_direction = -1
			if velocity.y > 0:
				velocity.y = 0
		elif Input.is_action_just_pressed("Right"):
			horizontal_direction = 1
			if velocity.x > 0:
				velocity.x = 0
		elif Input.is_action_just_pressed("Down"):
			vertical_direction = 1
			if velocity.y < 0:
				velocity.y = 0
		elif Input.is_action_just_pressed("Left"):
			horizontal_direction = -1
			if velocity.x < 0:
				velocity.x = 0
		
		if not Input.is_action_pressed("Up") and vertical_direction == -1:
			vertical_direction = 0
		elif not Input.is_action_pressed("Right") and horizontal_direction == 1:
			horizontal_direction = 0
		elif not Input.is_action_pressed("Down") and vertical_direction == 1:
			vertical_direction = 0
		elif not Input.is_action_pressed("Left") and horizontal_direction == -1:
			horizontal_direction = 0
		
		if Input.is_action_pressed("Up") and not Input.is_action_pressed("Down"):
			vertical_direction = -1
		elif Input.is_action_pressed("Down") and not Input.is_action_pressed("Up"):
			vertical_direction = 1
		if Input.is_action_pressed("Right") and not Input.is_action_pressed("Left"):
			horizontal_direction = 1
		elif Input.is_action_pressed("Left") and not Input.is_action_pressed("Right"):
			horizontal_direction = -1
		
	if Input.is_action_just_pressed("Dash") and dash_reset == true:
		dashing = true
		dash_reset = false
		$AnimatedSprite2D.scale.x = move_toward(1.0, 1.3, 8)
		$AnimatedSprite2D.scale.y = move_toward(1.0, 0.8, 8)
		$DashResetTimer.start()
		$DashTimer.start()
	
	var overall_direction = Vector2(horizontal_direction, vertical_direction).normalized()
	if dashing == true:
		velocity = overall_direction * speed * 10
	else:
		if velocity.length() > 200:
			velocity.x = move_toward(velocity.x, overall_direction.x * speed, 40)
			velocity.y = move_toward(velocity.y, overall_direction.y * speed, 40)
		else:
			velocity.x = move_toward(velocity.x, overall_direction.x * speed, 20)
			velocity.y = move_toward(velocity.y, overall_direction.y * speed, 20)
	
	
	if velocity.x > 5:
		last_horz_dir = 1
	elif velocity.x < -5:
		last_horz_dir = -1
		
		
	if last_horz_dir == 1:
		if velocity.length() > 5:
			$AnimatedSprite2D.play("MoveRight")
		else:
			$AnimatedSprite2D.play("IdleRight")
	elif last_horz_dir == -1:
		if velocity.length() > 5:
			$AnimatedSprite2D.play("MoveLeft")
		else:
			$AnimatedSprite2D.play("IdleLeft")
		
	
	#Sets a global variable that allows all scripts to know where the player is
	Global.player_position = global_position
	
	if Input.is_action_just_pressed("Shoot") and projectile_reloaded and ammo_rn > 0:
		var instance = projectile.instantiate()
		instance.dir = get_angle_to(get_global_mouse_position())
		instance.spawnPos = global_position
		instance.spawnRot = get_angle_to(get_global_mouse_position())
		level.add_child.call_deferred(instance)
		projectile_reloaded = false
		$ReloadTimer.start()
		ammo_rn -= 1
		if ammo_rn <= 0:
			ammo_rn = 0
			$RefillTimer.start()


	# refills ammo w timer when u run out
func _on_refill_timer_timeout() -> void:
	projectile_reloaded = true
	ammo_rn = max_ammo


	#Taking Damage
func take_damage():
	if health > 0 and dashing == false:
		health -= 1
		$GeneralHealthBar.update()
		invincible_frames = true
		Global.player_invincible = true
		$InvinicibleTimer.start()
		sprite_flash()
	
	#Makes player flash when taking damage
func sprite_flash():
	var tween: Tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate:v", 1, 0.25).from(15)

	#Ends the dash
func _on_dash_timer_timeout() -> void:
	dashing = false
	$AnimatedSprite2D.scale.x = move_toward($AnimatedSprite2D.scale.x, 1.0, 10)
	$AnimatedSprite2D.scale.y = move_toward($AnimatedSprite2D.scale.y, 1.0, 10)
	
	#reset time before dash can be used again
func _on_dash_reset_timer_timeout() -> void:
	dash_reset = true

	#Turns off invincibility from stuff like invul frames after taking dmg
func _on_invinicible_timer_timeout() -> void:
	invincible_frames = false
	Global.player_invincible = false





func _on_reload_timer_timeout() -> void:
	projectile_reloaded = true

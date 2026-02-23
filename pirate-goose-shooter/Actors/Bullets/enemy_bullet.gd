extends CharacterBody2D
@export var speed = 100

var dir: float
var spawnPos: Vector2
var spawnRot: float

#Spawns bullet on top of enemy and sets rotation
func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	
#Moves enemy in correct direction
func _physics_process(_delta: float) -> void:
	velocity = Vector2(speed, 0).rotated(dir)
	move_and_slide()

#Destroys bullet after hitting the player, tells player that it has taken dmg
func _on_area_2d_body_entered(body: Node2D) -> void:
	if Global.player_invincible == false:
		body.take_damage()
		queue_free()

#Destroys bullet after it has existed for a certain period of time
func _on_auto_destroy_timer_timeout() -> void:
	queue_free()

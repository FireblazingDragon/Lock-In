extends CharacterBody2D
@export var speed = 100

var dir: float
var spawnPos: Vector2
var spawnRot: float

#Creates bullet on player, puts initial rotation
func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	

func _physics_process(_delta: float) -> void:
	#Moves the bullet
	velocity = Vector2(speed, 0).rotated(dir)
	move_and_slide()

#Destroys the bullet if it hits an enemy, tells enemy it has taken dmg
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.take_damage()
		queue_free()

#Destroys the bullet if it has existed for a certain period of time to prevent it
#from just existing forever it it misses
func _on_auto_destroy_timer_timeout() -> void:
	queue_free()

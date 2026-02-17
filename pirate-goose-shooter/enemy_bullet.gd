extends CharacterBody2D
@export var speed = 100

var dir: float
var spawnPos: Vector2
var spawnRot: float


func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	

func _physics_process(_delta: float) -> void:
	velocity = Vector2(speed, 0).rotated(dir)
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if Global.player_invincible == false:
		body.take_damage()
		queue_free()

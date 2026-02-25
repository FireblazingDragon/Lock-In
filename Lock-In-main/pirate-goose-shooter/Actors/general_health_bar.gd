extends TextureProgressBar

@export var the_guy_with_this_health_bar : CharacterBody2D

func _ready() -> void:
	update()

#updates the health bar
func update():
	value = the_guy_with_this_health_bar.health * 100/the_guy_with_this_health_bar.max_health

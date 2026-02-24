extends Control


func _on_button_pressed() -> void:
	var fade = $CanvasLayer/ColorRect
	
	var tween = create_tween()
	tween.tween_property(
		fade,
		"color",
		Color(0, 0, 0, 1),
		0.8
	)
	
	await tween.finished
	get_tree().change_scene_to_file("res://level.tscn")
	
func _on_button_2_pressed() -> void:
	pass # will be credits


func _on_button_3_pressed() -> void:
	pass # will be settings

extends Control


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://level.tscn")
	pass


func _on_button_2_pressed() -> void:
	pass # will be credits


func _on_button_3_pressed() -> void:
	pass # will be settings

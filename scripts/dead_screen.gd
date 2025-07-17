extends Node2D

func _ready() -> void:
	$VrmNulDax3.play()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

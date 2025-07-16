extends Node2D

func _ready() -> void:
	$switch.start()

func _on_switch_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_2_ascenceur.tscn")

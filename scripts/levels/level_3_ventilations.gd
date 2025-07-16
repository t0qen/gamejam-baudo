extends Node2D

func _ready() -> void:
	$Timer.start()
	
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_4_salle_info.tscn")

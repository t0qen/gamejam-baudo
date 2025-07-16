extends Node2D

func _ready() -> void:
	$Timer.start()


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/boss_fight.tscn")

extends Node2D


func _on_timer_timeout() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/pcmain.tscn")

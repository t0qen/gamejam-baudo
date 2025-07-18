extends Node2D

func _ready() -> void:
	global.is_dax_speek = true
	$BlagueDax3.play()

func _on_timer_timeout() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/pcmain.tscn")


func _on_blague_dax_3_finished() -> void:
	global.is_dax_speek = false

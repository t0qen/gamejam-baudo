extends Node2D

func _ready() -> void:
	global.is_dax_speek = true
	$VrmNulDax3.play()

func _on_button_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")


func _on_vrm_nul_dax_3_finished() -> void:
	global.is_dax_speek = false

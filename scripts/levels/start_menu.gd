extends Node2D

func  _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Menu.play()
	
func _on_start_pressed() -> void:
	print("PRESSED")
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/cinematic_1.tscn")


func _on_credits_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/credits.tscn")

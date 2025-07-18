extends Control

@onready var quit_label: Label = $quit_label

func _on_quit_pressed() -> void:
	quit_label.show()
	await get_tree().create_timer(2)
	quit_label.hide()

func _on_start_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/cinematic_1.tscn")

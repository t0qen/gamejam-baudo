extends Control

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play("crédits")
	

	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	await get_tree().create_timer(2).timeout
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/start_menu.tscn")

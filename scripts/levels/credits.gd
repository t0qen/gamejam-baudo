extends Control

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	$AnimationPlayer.play("crédits")
	

	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://scenes/levels/start_menu.tscn")

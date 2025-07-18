extends Node2D

func _ready() -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Transition.transition()
		await Transition.on_transition_finished
		get_tree().change_scene_to_file("res://scenes/levels/boss_fight.tscn")

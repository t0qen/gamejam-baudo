extends Node2D

func _ready() -> void:
	global.is_dax_speek = true
	$BlagueDax1.play()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Transition.transition()
		await Transition.on_transition_finished
		get_tree().change_scene_to_file("res://scenes/levels/boss_fight.tscn")


func _on_blague_dax_1_finished() -> void:
	global.is_dax_speek = false

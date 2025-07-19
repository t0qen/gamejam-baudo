extends Node2D

func _ready() -> void:	
	$"Salut!MoiC'estDax!".play()
	global.is_dax_speek = true


func _on_salut_moi_cest_dax_finished() -> void:
	await get_tree().create_timer(2).timeout
	$NousVoilaDansLimmeuble.play()


func _on_end_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		await get_tree().create_timer(1).timeout
		Transition.transition()
		await Transition.on_transition_finished
		get_tree().change_scene_to_file("res://scenes/levels/level_2_ascenceur.tscn")


func _on_nous_voila_dans_limmeuble_finished() -> void:
	global.is_dax_speek = false
	await get_tree().create_timer(2).timeout
	$music.play()

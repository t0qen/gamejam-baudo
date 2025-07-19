extends Node2D

func _ready() -> void:
	global.is_dax_speek = true
	$Villa.play()
	await get_tree().create_timer(2.5).timeout
	$Villa.stop()
	global.is_dax_speek = false
	await get_tree().create_timer(1).timeout
	$BlagueDax1.play()
	global.is_dax_speek = true
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Transition.transition()
		await Transition.on_transition_finished
		get_tree().change_scene_to_file("res://scenes/levels/boss_fight.tscn")


func _on_blague_dax_1_finished() -> void:
	global.is_dax_speek = false

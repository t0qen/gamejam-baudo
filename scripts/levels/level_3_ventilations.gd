extends Node2D

var is_player_in_vent : bool = false

func _ready() -> void:
	global.is_dax_speek = true
	$TrouveLaSortie.play()
	
	
	

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("action") and global.player_press_e && !is_player_in_vent:
		is_player_in_vent = true
		$SFX.play()
		await get_tree().create_timer(1.5).timeout
		Transition.transition()
		await Transition.on_transition_finished
		get_tree().change_scene_to_file("res://scenes/levels/level_4_salle_info.tscn")


func _on_vent_3_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.player_press_e = true
	


func _on_vent_3_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.player_press_e = false


func _on_blague_dax_4_finished() -> void:
	global.is_dax_speek = false
	await get_tree().create_timer(2).timeout
	$music.play()


func _on_trouve_la_sortie_finished() -> void:
	global.is_dax_speek = false
	await get_tree().create_timer(1).timeout
	global.is_dax_speek = true
	$BlagueDax4.play()

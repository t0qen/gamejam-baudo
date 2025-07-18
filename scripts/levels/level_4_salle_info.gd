extends Node2D

func _ready() -> void:
	global.is_dax_speek = true
	$BlagueDax7.play()
	
	

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("action") and global.player_press_e:
		$AudioStreamPlayer.play()
		await get_tree().create_timer(1).timeout
		Transition.transition()
		await Transition.on_transition_finished
		get_tree().change_scene_to_file("res://scenes/pcmain.tscn")


func _on_blague_dax_7_finished() -> void:
	global.is_dax_speek = false
	await get_tree().create_timer(1.5).timeout
	global.is_dax_speek = true
	$InsereCleusb.play()


func _on_vent_3_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.player_press_e = true


func _on_vent_3_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.player_press_e = false


func _on_insere_cleusb_finished() -> void:
	global.is_dax_speek = false

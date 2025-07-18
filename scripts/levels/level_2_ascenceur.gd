extends Node2D
#coucou
var is_step_1_complete : bool = false
var tremble : bool = true
var can_step_2 : bool = true
var body_in_step1 : bool = false
var body_in_vent : bool = false
var step2_did : bool = false
var body_has_been_vent : bool = false

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	print("BEGIN SCENE")
	$porte1.hide()
	$porte2.hide()
	$hide_suite.show()
	$Block_Gate2/CollisionShape2D.disabled = false
	$block_gate/CollisionShape2D.disabled = false
	$Timer.start()
	$sound.play()
	while tremble == true:
		CameraManager.shake(0.5,  1.5, Vector2(50, 100), 0.1)
		await get_tree().create_timer(0.5).timeout
	$sound.stop()
	print("step0")
	await  get_tree().create_timer(1).timeout
	$ding.play()
	$block_gate/CollisionShape2D.disabled = true
	$porte1.show()
	$occluders/porte_ouverte1.show()
	$"occluders/porte_fermée1".hide()
	
	$hide_etage.hide()
	$hide_etage2.hide()
	$hide_etage3.hide()
	await get_tree().create_timer(1).timeout
	global.is_dax_speek = true
	$RecupereCleUsb.play()
	
	
# SOUND HAS BEEN PLAYED
	
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("action") and global.player_press_e and body_in_step1:
		print("step1")
		is_step_1_complete = true
		$step1.queue_free()
		$AsceuseurKey.queue_free()
		$PointLight2D3.hide()
		tremble = true
		$key.play()
		await get_tree().create_timer(1).timeout
		global.is_dax_speek = true
		$RetourneDansLascenseur.play()
	if Input.is_action_just_pressed("action") and global.player_press_e and body_in_vent && !body_has_been_vent:
		body_has_been_vent = true
		$PointLight2D2.hide()
		$SFX.play()
		await get_tree().create_timer(1.5).timeout
		Transition.transition()
		await Transition.on_transition_finished
		get_tree().change_scene_to_file("res://scenes/levels/level_3_ventilations.tscn")

func _on_step_2_body_entered(body: Node2D) -> void:
	print("step2")
	print(body)
	if is_step_1_complete && !step2_did:
		step2_did = true
		$block_gate/CollisionShape2D.call_deferred("set", "disabled", false)
		$porte1.hide()
		$occluders/porte_ouverte1.hide()
		$"occluders/porte_fermée1".show()
		$hide_etage.show()
		$hide_etage2.show()
		$hide_etage3.show()
		$Timer.start()
		$enemies.hide()
		$sound.play()
		while tremble == true:
			CameraManager.shake(0.5,  1.5, Vector2(50, 100), 0.1)
			await get_tree().create_timer(0.5).timeout
		
		$ding.play()
		$block_gate/CollisionShape2D.call_deferred("set", "disabled", false)
		$Block_Gate2/CollisionShape2D.call_deferred("set", "disabled", true)
		$porte2.show()
		$"occluders/porte_fermée2".hide()
		$occluders/porte_ouverte2.show()
		$hide_suite.hide()
		
func _on_timer_timeout() -> void:
	tremble = false


func _on_vent_3_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		body_in_vent = true
		global.player_press_e = true


func _on_vent_3_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		body_in_vent = false
		global.player_press_e = false
	


func _on_step_1_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		body_in_step1 = true
		global.player_press_e = true
	


func _on_step_1_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		body_in_step1 = false
		global.player_press_e = false


func _on_retourne_dans_lascenseur_finished() -> void:
	global.is_dax_speek = false


func _on_recupere_cle_usb_finished() -> void:
	global.is_dax_speek = false
	$music.play()

extends Node2D

var is_step_1_complete : bool = false
var tremble : bool = true
var can_step_2 : bool = true
var body_in_step1 : bool = false
var body_in_vent : bool = false

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	print("BEGIN SCENE")
	$noirgauche.show()
	$hide_suite.show()
	$noirhaut.show()
	$Block_Gate2/CollisionShape2D.disabled = false
	$block_gate/CollisionShape2D.disabled = false
	$Timer.start()
	while tremble == true:
		CameraManager.shake(0.5,  1.5, Vector2(50, 100), 0.1)
		await get_tree().create_timer(0.5).timeout
	print("step0")
	$block_gate/CollisionShape2D.disabled = true
	$noirgauche.hide()
	$hide_etage.hide()
	$Arrow2.show()
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("action") and global.player_press_e and body_in_step1:
		print("step1")
		$Arrow1.show()
		$Arrow2.hide()
		is_step_1_complete = true
		$AsceuseurKey.hide()
		tremble = true
	if Input.is_action_just_pressed("action") and global.player_press_e and body_in_vent:
		Transition.transition()
		await Transition.on_transition_finished
		get_tree().change_scene_to_file("res://scenes/levels/level_3_ventilations.tscn")

func _on_step_2_body_entered(body: Node2D) -> void:
	print("step2")
	print(body)
	if is_step_1_complete:
		$block_gate/CollisionShape2D.call_deferred("set", "disabled", false)
		$hide_etage.show()
		$noirgauche.show()
		$Timer.start()
		$enemies.hide()
		while tremble == true:
			CameraManager.shake(0.5,  1.5, Vector2(50, 100), 0.1)
			await get_tree().create_timer(0.5).timeout
		$block_gate/CollisionShape2D.call_deferred("set", "disabled", false)
		$Block_Gate2/CollisionShape2D.call_deferred("set", "disabled", true)
		$hide_suite.hide()
		$noirhaut.hide()
		
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

extends Node2D

var is_step_1_complete : bool = false


func _ready() -> void:
	await get_tree().create_timer(1).timeout
	print("BEGIN SCENE")
	CameraManager.shake(0.5,  1.6, Vector2(50, 100), 0.1)
	await get_tree().create_timer(2).timeout
	$block_gate/CollisionShape2D.disabled = true
	$hide_etage.hide()
	$Arrow2.show()




func _on_step_1_area_entered(area: Area2D) -> void:
	print(area)
	$Arrow1.show()
	$Arrow2.hide()
	is_step_1_complete = true
	$AsceuseurKey.hide()


func _on_step_2_body_entered(body: Node2D) -> void:
	print(body)
	if is_step_1_complete:
		await get_tree().create_timer(1).timeout
		$hide_etage.show()
		$block_gate/CollisionShape2D.disabled = false
		await get_tree().create_timer(2).timeout
		CameraManager.shake(0.5,  1.6, Vector2(50, 100), 0.1)
		$hide_suite.hide()
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://scenes/levels/level_3_ventilations.tscn")

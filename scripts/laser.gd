extends StaticBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		body.laser_attack()


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass

	if area.is_in_group("player"):
		global.need_to_take_damage_laser = true

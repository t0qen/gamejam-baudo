extends Node2D

func _ready() -> void:	
	$"Salut!MoiC'estDax!".play()
	global.is_dax_speek = true
	$switch.start()

func _on_switch_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_2_ascenceur.tscn")


func _on_salut_moi_cest_dax_finished() -> void:
	global.is_dax_speek = false

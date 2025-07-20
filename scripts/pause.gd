extends Node2D

var is_paused : bool = false 

func _ready() -> void:
	hide()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		
		get_tree().paused = true
		is_paused = true
		show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_reprendre_pressed() -> void:
	get_tree().paused = false
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/start_menu.tscn")

extends Control

var can_play : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$PopUp.hide()

func _on_naviguateur_pressed() -> void:
	if can_play:
		can_play = false
		$"NousNeSommePasLàPourS'abonner".play()

func _on_nous_ne_somme_pas_là_pour_sabonner_finished() -> void:
	can_play = true


func _on_cle_usb_pressed() -> void:
	$PopUp.show()
	$PopUp/AnimatedSprite2D.play("loading")


func _on_animated_sprite_2d_animation_finished() -> void:
	$PopUp/Label.text = "8780 Rue du Soir"
	$AllonsAttraperMarGamerBoy.play()
	


func _on_allons_attraper_mar_gamer_boy_finished() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/level_5.tscn")

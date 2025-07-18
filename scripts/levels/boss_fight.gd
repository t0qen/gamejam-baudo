extends Node2D

var is_boss_dead : bool = false
var is_dialoguing : bool = false
var is_dialogue_finished : bool = false
var can_pass_dialogue : bool = true

enum dialogue {
	DIALOGUE1,
	DIALOGUE2,
	DIALOGUE3,
	FINISHED
}
var current_dialogue : dialogue = dialogue.DIALOGUE1
var prev_dialogue : dialogue

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		if is_dialoguing:
			match prev_dialogue:
				dialogue.DIALOGUE1:
					current_dialogue = dialogue.DIALOGUE2
				dialogue.DIALOGUE2:
					current_dialogue = dialogue.DIALOGUE3
				dialogue.DIALOGUE3:
					current_dialogue = dialogue.FINISHED
			update_dialogue()
	

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$player.hide()
	await get_tree().create_timer(2).timeout
	is_dialoguing = true
	$dialogue.show()
	update_dialogue()
	while !is_dialogue_finished:
		await get_tree().create_timer(0.1).timeout
		print("waiting for dialogue reachs end")
	
	print("BOSS FIGHT START !!")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$player.show()
	$Boss.start_cycle()
	$music.play()


func update_dialogue():
	prev_dialogue = current_dialogue
	match current_dialogue:
		dialogue.DIALOGUE1:
			$"dialogue/dialogue 1".show()
		dialogue.DIALOGUE2:
			$"dialogue/dialogue 1".hide()
			$"dialogue/dialogue 2".show()
		dialogue.DIALOGUE3:
			$"dialogue/dialogue 2".hide()
			$"dialogue/dialogue 3".show()
		dialogue.FINISHED:
			$"dialogue/dialogue 3".hide()
			$dialogue.hide()
			is_dialoguing = false
			is_dialogue_finished = true


func _on_boss_boss_dead() -> void:
	$music.stop()
	is_boss_dead = true
	await get_tree().create_timer(2).timeout
	$player.queue_free()
	$dialogue.show()
	$dialogue/Button.hide()
	$"dialogue/dialogue 4".show()
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file("res://scenes/levels/cinematic_2.tscn")
	


func _on_button_pressed() -> void:
	print("PASS")
	if can_pass_dialogue:
		can_pass_dialogue = false
		if is_dialoguing:
			match prev_dialogue:
				dialogue.DIALOGUE1:
					current_dialogue = dialogue.DIALOGUE2
				dialogue.DIALOGUE2:
					current_dialogue = dialogue.DIALOGUE3
				dialogue.DIALOGUE3:
					current_dialogue = dialogue.FINISHED
			update_dialogue()
			await get_tree().create_timer(1).timeout
			can_pass_dialogue = true


func _on_music_finished() -> void:
	if !is_boss_dead:
		$music.play()

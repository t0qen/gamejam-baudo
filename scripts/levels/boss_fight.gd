extends Node2D

var is_boss_dead : bool = false

func _ready() -> void:
	print("BOSS FIGHT START !!")
	$Boss.start_cycle()
	$AudioStreamPlayer2D.play()


func _on_audio_stream_player_2d_finished() -> void:
	if !is_boss_dead:
		$AudioStreamPlayer2D.play()


func _on_boss_boss_dead() -> void:
	$AudioStreamPlayer2D.stop()
	is_boss_dead = true

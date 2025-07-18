extends Node2D

func _ready() -> void:
	print("BOSS FIGHT START !!")
	$Boss.start_cycle()
	$AudioStreamPlayer2D.play()

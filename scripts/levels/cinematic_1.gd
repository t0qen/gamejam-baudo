extends Node2D
@onready var switch: Timer = $switch

func _ready() -> void:
	switch.start()
	
func _on_switch_timeout() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

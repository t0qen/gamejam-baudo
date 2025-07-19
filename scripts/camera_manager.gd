extends Node

var current_cam = null



func set_current_cam(cam):
	current_cam = cam
	
func shake(trauma : float = 0.5, changed_decay : float = 0.8, changed_max_offset : Vector2 = Vector2(50, 50), changed_max_roll : float = 0.1):
	reset()
	current_cam.start_shake(trauma, changed_decay, changed_max_offset, changed_max_roll)
	
func reset():
	current_cam.reset_trauma()

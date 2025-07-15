extends CharacterBody2D

@export var player : CharacterBody2D # store player from main scene
var player_position : Vector2
var move_toward_player : bool = false
@export var BASE_SPEED : int = 500
var current_speed : int = BASE_SPEED

# /* FUNCTION */

# MAIN
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if move_toward_player:
		print("MOVE TOWARD PLAYER")
		player_position = player.global_position
		look_at(player_position)
		var direction : Vector2 = (player.position - position).normalized()
		velocity = direction * current_speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
		
# SUB

# SIGNALS

# If player enter in player detection area the enemy starts move toward him

func _on_player_detection_body_entered(body: Node2D) -> void:
	move_toward_player = true
	print("TRUE")

func _on_player_detection_body_exited(body: Node2D) -> void:
	move_toward_player = false
	print("FALSE")
	
# If player enter in attack range, enemy will stop and attack player

func _on_attack_range_body_entered(body: Node2D) -> void:
	current_speed = 0 

func _on_attack_range_body_exited(body: Node2D) -> void:
	current_speed = BASE_SPEED

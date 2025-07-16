extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed : int = 400
var player_chase : bool = false
var player_chase_move : bool = true

var health : int = 100
var player_inattack_zone = false
var can_take_damage = true

@export var player : CharacterBody2D
var DetectionRotation : int = 0
var can_rotate : bool = true
	
func _physics_process(delta: float) -> void:
	deal_with_damage()
	
	if player_chase:
		print("CHASE")
		var target_direction = (player.global_position - global_position).normalized()
		velocity = target_direction * speed
		
		position += (player.position - position) / speed
		$PlayerDetection.look_at(player.global_position)
		
		if(player.position.x - position.x) < 0:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
			
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()
		

func _on_player_detection_body_entered(body: Node2D) -> void:
	
	if body.has_method("player"):
		print("ENTRED ", body)
		if can_rotate:
			player_chase = true
			print("CAN")
			can_rotate = false
			DetectionRotation += 1
			$PlayerDetection.rotation = DetectionRotation / 2
			$RotationDelay.start(0.5)
			
func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_chase = false
		
func enemy():
	pass

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		print("ENTERED")
		player_chase_move = false
		player_inattack_zone = true


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_chase_move = true
		player_inattack_zone = false

func deal_with_damage():
	if player_inattack_zone == true and global.player_current_attack == true:
		if can_take_damage == true:
			
			health = health - 35
			$take_damage_cooldown.start()
			can_take_damage = false
			
			if health <= 0:
				# DEAD
				self.queue_free()
				
			$AnimatedSprite2D.modulate = Color.RED
			await get_tree().create_timer(0.1).timeout
			$AnimatedSprite2D.modulate = Color.WHITE

func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true


func _on_rotation_delay_timeout() -> void:
	can_rotate = true

extends CharacterBody2D

# /* VARIABLE */
@onready var idle_anim: AnimatedSprite2D = $animations/pivot_idle/idle
@onready var attack_anim: AnimatedSprite2D = $animations/pivot_attack/attack
@onready var run_anim: AnimatedSprite2D = $animations/pivot_run/run
@onready var dead_anim: AnimatedSprite2D = $animations/pivot_dead/dead
var current_animation : String
var prev_animation : String

@export var player : CharacterBody2D
@export var speed : int = 400

var is_attacking : bool = false
var alive : bool = true
var player_chase : bool = false
var player_chase_move : bool = true


var health : int = 100
var player_inattack_zone = false
var can_take_damage = true
var DetectionRotation : int = 0
var can_rotate : bool = true
var can_scope : bool = true 


# /* FUNCTION */

# PLAYER CHASE
func handle_chase():
	var target_direction = (player.global_position - global_position).normalized()
	velocity = target_direction * speed
	$PlayerDetection.look_at(player.global_position)


# ANIMATIONS
func flip_animation(input):
	var excepted_flip : int
	if input > 0:
		excepted_flip = -1
	else:
		excepted_flip = 1
	
	for child in $animations.get_children():
		child.scale.x = excepted_flip
		
		
func play_animation(animation):
	if prev_animation == animation:
		return
	# cache et stop tous les enfants de animations
	for child in $animations.get_children():
		for anim_child in child.get_children():
			anim_child.stop()
			anim_child.hide()
	
	current_animation = animation
	prev_animation = current_animation
	print(current_animation)
	match animation:
		"dead":
			dead_anim.show()
			dead_anim.play("default")
		"run": 
			run_anim.show()
			run_anim.play("default")
		"attack":
			attack_anim.show()
			attack_anim.play("default")
		"idle":
			idle_anim.show()
			idle_anim.play("default")


















# --------------------------------------------------------------------------------
	
func _ready() -> void:
	play_animation("idle")
	
func _physics_process(delta: float) -> void:
	Engine.time_scale = 0.1
	if alive:
		deal_with_damage()
			
		if player_chase:
			
			if player_chase_move:
				#if !is_attacking:
				#	play_animation("run")
				
			else:
				velocity = Vector2.ZERO
				
			
			
			if velocity.x != 0:
				flip_animation(velocity.x)
					 
				
		else:
			if !is_attacking:
				play_animation("idle")
			velocity = Vector2.ZERO
			if can_scope:
				can_scope = false
				DetectionRotation += 1
				$PlayerDetection.rotation = DetectionRotation / 2
				await get_tree().create_timer(0.2).timeout
				can_scope = true

		if global.enemy_need_to_attack_anim:
			is_attacking = true
			#global.enemy_need_to_attack_anim = false
			print("PLAYER ATTACK ANIM")
			velocity = Vector2.ZERO
			play_animation("attack")
			await get_tree().create_timer(1).timeout
			is_attacking = false

			
	if health <= 0 && alive:
		$dye_enemy.play()
		$Collisions.disabled = true
		velocity = Vector2.ZERO
		$PlayerDetection.queue_free()
		$EnemyHitbox.queue_free()
		alive = false
		play_animation("dead")
		$wait_death.start()
		
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
			
			health = health - 20
			$take_damage_cooldown.start()
			can_take_damage = false
			
			
				
			$animations.modulate = Color.RED
			await get_tree().create_timer(0.1).timeout
			$animations.modulate = Color.WHITE

func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true


func _on_rotation_delay_timeout() -> void:
	can_rotate = true


func _on_wait_death_timeout() -> void:
	self.queue_free()

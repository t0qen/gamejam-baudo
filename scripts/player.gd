extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 160
var player_alive = true

var attack_ip = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var direction = 1

const SPEED = 400
const ACCELERATION = 1500
const FRICTION = 200

var input = Vector2.ZERO


func player_movement(input, delta):
	if input: 
		velocity = velocity.move_toward(input * SPEED , delta * ACCELERATION)
	else: 
		velocity = velocity.move_toward(Vector2(0,0), delta * FRICTION)
		if attack_ip == false:
			animated_sprite_2d.play("idle")

func _physics_process(delta):
	
	var input = Input.get_vector("move_left","move_right","move_up","move_down")
	player_movement(input, delta)
	
	if input.x != 0:
		animated_sprite_2d.flip_h = input.x < 0
		
	move_and_slide()
	enemy_attack()
	attack()
	
	if health <= 0:
		player_alive = false #ajouter un ecran de fin
		self.queue_free()

func player():
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = true


func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = false
		
func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$attack_cooldown.start(0.5)
		print(health)

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true

func attack():
	if Input.is_action_just_pressed("attack"):
		print("action press")
		global.player_current_attack = true
		attack_ip = true
		$deal_attack_timer.start()

func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false

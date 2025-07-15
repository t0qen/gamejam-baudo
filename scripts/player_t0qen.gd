extends CharacterBody2D

# /* VARIABLES */
# TIMERS
@onready var dash_duration_timer: Timer = $timers/dash_duration
@onready var dash_delay_timer: Timer = $timers/dash_delay

# MOVEMENTS
@export var speed = 400
@export var friction = 0.5
@export var acceleration = 0.5

# DASH
var can_dash : bool = true
var is_dashing : bool = false
@export var dash_force : int = 1000

# ATTAQUE ET VIE
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 160
var player_alive = true
var attack_ip = false
var can_attack = true

# INPUTS
var prev_inputs : int = 0 # useful for determine flip sprite

# NODES
@onready var sprite: AnimatedSprite2D = $sprite

# /* FUNCTIONS */

# MAIN
func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	move()
	dash()
	move_and_slide()
	enemy_attack()
	attack()
	
	if health <= 0: # Tue le joueur si il a 0 vie
		player_alive = false # ajouter un ecran de fin
		self.queue_free()
	
# SUB 
func get_inputs(): # func to get current inputs
	var input = Vector2()
	# get input per keys, better than Input.get_vectors()
	if Input.is_action_pressed('move_right'):
		input.x += 1
	if Input.is_action_pressed('move_left'):
		input.x -= 1
	if Input.is_action_pressed('move_down'):
		input.y += 1
	if Input.is_action_pressed('move_up'):
		input.y -= 1
	if input.x != 0:
		flip_sprite(input.x)
	return input
	
func flip_sprite(value): # flip sprite with player direction
	if value > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	
func move(): # func to move player 
	var direction : Vector2 = get_inputs()
	if direction.length() > 0: # if player wants to move
		if !attack_ip:
			sprite.play("run")
			
		if is_dashing:
				velocity = direction.normalized() * dash_force # smooth acceleration without dash
		else:
			
			velocity = velocity.lerp(direction.normalized() * speed, acceleration) # smooth acceleration without dash
	else:
		if !attack_ip:
			sprite.play("idle")
		velocity = velocity.lerp(Vector2.ZERO, friction) # smooth stop

func dash(): # determine if player can dash and perform dash
	if Input.is_action_just_pressed("dash"):
		if can_dash:
			if !is_dashing:
				if !attack_ip:
					print("DASHING !!")
					is_dashing = true
					dash_duration_timer.start() # dash duration
					can_dash = false
				else:
					return
			else:
				return
		else:
			return
	else:
		return
		
func player(): # Permet au joueur de se faire détecter pas l'ennemi
	pass
		
# SIGNALS
func _on_dash_delay_timeout() -> void: # delay when player can't dash
	print("DASH DELAY FINISHED")
	can_dash = true

func _on_dash_duration_timeout() -> void: # dash duration
	print("DASH FINISHED")
	is_dashing = false
	dash_delay_timer.start()
	
func _on_player_hitbox_body_entered(body: Node2D) -> void: # Détecte quand l'ennemi est à porté
	if body.has_method("enemy"):
		enemy_inattack_range = true


func _on_player_hitbox_body_exited(body: Node2D) -> void: # Détecte quand l'ennemi n'est plus à porté
	if body.has_method("enemy"):
		enemy_inattack_range = false
		
func enemy_attack(): # Détecte quand l'ennemi attaque et enlève les dégâts nécessaires
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$timers/attack_cooldown.start(0.5)
		print(health)

func _on_attack_cooldown_timeout() -> void: # Cooldown de l'attaque
	enemy_attack_cooldown = true

func attack(): # Permet d'attaquer
	if Input.is_action_just_pressed("attack"):
		if can_attack:
			print("action press")
			global.player_current_attack = true
			attack_ip = true
			$timers/deal_attack_timer.start(0.5)
			can_attack = false
			print("deal_attack_timer.start")

func _on_deal_attack_timer_timeout() -> void: # Fin de l'attaque
	$timers/deal_attack_timer.stop()
	print("deal_attack_timer.stop")
	global.player_current_attack = false
	attack_ip = false
	can_attack = true

extends CharacterBody2D

# /* VARIABLES */
@export var will_instanciate_cam : bool = true
var cam = preload("res://scenes/camera.tscn")

# TIMERS
@onready var dash_duration_timer: Timer = $timers/dash_duration
@onready var dash_delay_timer: Timer = $timers/dash_delay
@onready var regen_start_timer: Timer = $timers/regen_start

# MOVEMENTS
@export var speed = 400
@export var friction = 0.5
@export var acceleration = 0.5

# DASH
var can_dash : bool = true
var is_dashing : bool = false
@export var dash_force : int = 2000

# ATTAQUE ET VIE
var enemy_inattack_range = false
var enemy_attack_cooldown = true
@export var HEALTH : int = 160
var current_health : int = HEALTH
var player_alive : bool = true
var attack_ip : bool = false
var can_attack : bool = true
var can_receive_boss_attack : bool = true
var is_on_boss_attack_area : bool = false

	# -- REGEN
@export var regen_step : int = 40
var can_regen : bool = true

# INPUTS
var prev_inputs : int = 0 # useful for determine flip sprite

# NODES
@onready var sprite : AnimatedSprite2D = $sprite
@export var boss_node : CharacterBody2D  
	# -- UI
@onready var health_bar: ProgressBar = $health_bar

# /* FUNCTIONS */

# MAIN
func _ready() -> void:
	if will_instanciate_cam:
		var current_cam = cam.instantiate()
		add_child(current_cam)
		current_cam.global_position = global_position
		
	# Setup health ui
	health_bar.max_value = HEALTH
	health_bar.value = HEALTH
	
func _process(delta: float) -> void:
	update_health_bar()
	
func _physics_process(delta: float) -> void:
	move()
	dash()
	regen()
	move_and_slide()
	enemy_attack()
	attack()
	
	if is_on_boss_attack_area:
		if can_receive_boss_attack:
			if boss_node.is_attacking:
				boss_attack()
				can_receive_boss_attack = false
				await get_tree().create_timer(2).timeout
				can_receive_boss_attack = true
		
	
	if current_health <= 0: # Tue le joueur si il a 0 vie
		player_alive = false # ajouter un ecran de fin
		get_tree().change_scene_to_file("res://scenes/dead_screen.tscn")
			
# SUB 
func regen():
	if can_regen:
		if current_health < HEALTH:
			print("REGEN")
			current_health = HEALTH
			can_regen = false
			regen_start_timer.start()
	else:
		return
	
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
	print(input)
	return input
	
func flip_sprite(value): # flip sprite with player direction
	if value > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	
func update_health_bar():
	health_bar.value = current_health
	
func move(): # func to move player 
	var direction : Vector2 = get_inputs()
	#print(direction)
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
	is_dashing = false
	dash_delay_timer.start()
	
func _on_player_hitbox_body_entered(body: Node2D) -> void: # Détecte quand l'ennemi est à porté
	if body.has_method("enemy"):
		print("enemy in")
		enemy_inattack_range = true
	

func _on_player_hitbox_body_exited(body: Node2D) -> void: # Détecte quand l'ennemi n'est plus à porté
	if body.has_method("enemy"):
		enemy_inattack_range = false
		
func enemy_attack(): # Détecte quand l'ennemi attaque et enlève les dégâts nécessaires
	if enemy_inattack_range and enemy_attack_cooldown == true:
		print("enemy attack !")
		current_health = current_health - 20
		
		can_regen = false
		if regen_start_timer.time_left > 0: # timer is active
			regen_start_timer.stop()
			regen_start_timer.start()
		else:
			regen_start_timer.start()
			
		enemy_attack_cooldown = false
		$timers/attack_cooldown.start(0.5)

		sprite.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		sprite.modulate = Color.WHITE

func boss_attack():
	current_health = current_health - 60
	can_regen = false
	if regen_start_timer.time_left > 0: # timer is active
		regen_start_timer.stop()
		regen_start_timer.start()
	else:
		regen_start_timer.start()
		
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	sprite.modulate = Color.WHITE
			
func _on_attack_cooldown_timeout() -> void: # Cooldown de l'attaque
	enemy_attack_cooldown = true

func attack(): # Permet d'attaquer
	if Input.is_action_just_pressed("attack"):
		if can_attack:
			global.player_current_attack = true
			attack_ip = true
			$timers/deal_attack_timer.start(0.5)
			can_attack = false

func _on_deal_attack_timer_timeout() -> void: # Fin de l'attaque
	$timers/deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false
	can_attack = true

func _on_regen_start_timeout() -> void:
	can_regen = true


func _on_player_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("boss"):
		is_on_boss_attack_area = true
	if area.is_in_group("attack_hitbox"):
		global.player_can_attack_boss = true

func _on_player_hitbox_area_exited(area: Area2D) -> void:
	if area.is_in_group("boss"):
		is_on_boss_attack_area = false
	if area.is_in_group("attack_hitbox"):
		global.player_can_attack_boss = false

extends CharacterBody2D

# /* VARIABLES */
@export var will_instanciate_cam : bool = true
var cam = preload("res://scenes/camera.tscn")

# ANIMATIONS
@onready var idle_anim: AnimatedSprite2D = $animations/pivot_idle/idle
@onready var dash_anim: AnimatedSprite2D = $animations/pivot_dash/dash
@onready var attack_3_anim: AnimatedSprite2D = $animations/pivot_attack3/attack3
@onready var attack_2_anim: AnimatedSprite2D = $animations/pivot_attack2/attack2
@onready var attack_1_anim: AnimatedSprite2D = $animations/pivot_attack1/attack1
@onready var run_anim: AnimatedSprite2D = $animations/pivot_run/run
@onready var dead_anim: AnimatedSprite2D = $animations/pivot_dead/dead

var current_animation : String 
var prev_animation : String

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
@export var boss_node : CharacterBody2D  
	# -- UI
@onready var health_bar: ProgressBar = $health_bar

# /* FUNCTIONS */

# MAIN
func _ready() -> void:
	play_animation("idle")
	if will_instanciate_cam:
		var current_cam = cam.instantiate()
		add_child(current_cam)
		current_cam.global_position = global_position
		
	# Setup health ui
	health_bar.max_value = HEALTH
	health_bar.value = HEALTH
	
	# Setup Dash ui
	$Dash.frame = 0
	
func _process(delta: float) -> void:
	update_health_bar()
	
func _physics_process(delta: float) -> void:
	#Engine.time_scale = 0.1
	if player_alive :
		if global.need_to_take_damage_laser:
			laser_attack()
			
		if !attack_ip:
			move()
		dash()
		regen()
		move_and_slide()
		enemy_attack()
		attack()
		
		if is_on_boss_attack_area:
			if can_receive_boss_attack:
				if global.player_attacked_by_boss:
					boss_attack()
					can_receive_boss_attack = false
					await get_tree().create_timer(2).timeout
					can_receive_boss_attack = true
		
		if global.player_press_e:
			$Label.show()
		else:
			$Label.hide()
		
	if current_health <= 0 && player_alive : # Tue le joueur si il a 0 vie
		print("dead")
		player_alive = false # ajouter un ecran de fin
		play_animation("dead") 
		$timers/wait_death.start()
		print("started timer")
		
	
	
# SUB 
func random_attack_anim():
	var all_attack_anim = ["attack1", "attack2", "attack3"]
	return all_attack_anim.pick_random()

func flip_animation(input):
	var excepted_flip : int
	
	
	for child in $animations.get_children():
		if input < 0:
			child.scale.x = -1
		else:
			child.scale.x = 1
		
		
	#match current_animation:
		#"run": 
			#run_animation.flip_h = excepted_flip
		#"dash":
			#dash_animation.flip_h = excepted_flip
		#"attack1":
			#attack_1_animation.flip_h = excepted_flip
		#"attack2":
			#attack_2_animation.flip_h = excepted_flip
		#"attack3":
			#attack_3_animation.flip_h = excepted_flip
		#"idle":
			#idle_animation.flip_h = excepted_flip

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
	match animation:
		"dead":
			dead_anim.show()
			dead_anim.play("default")
		"run": 
			run_anim.show()
			run_anim.play("default")
		"dash":
			dash_anim.show()
			dash_anim.play("default")
		"attack1":
			$attack.play()
			attack_1_anim.show()
			attack_1_anim.play("default")
		"attack2":
			$attack.play()
			attack_2_anim.show()
			attack_2_anim.play("default")
		"attack3":
			$attack.play()
			attack_3_anim.show()
			attack_3_anim.play("default")
		"idle":
			idle_anim.show()
			idle_anim.play("default")

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
		#input.x += 1
		input.x = 1
	if Input.is_action_pressed('move_left'):
		#input.x -= 1
		input.x = -1
	if Input.is_action_pressed('move_down'):
		#input.y += 1
		input.y = 1
	if Input.is_action_pressed('move_up'):
		#input.y -= 1
		input.y = -1
	if input.x != 0:
		flip_animation(input.x)
	return input
	
	
func update_health_bar():
	health_bar.value = current_health
	
func move(): # func to move player 
	var direction : Vector2 = get_inputs()
	#print(direction)
	if direction.length() > 0: # if player wants to move
		if is_dashing:
			if !attack_ip:
				play_animation("dash")
			velocity = direction.normalized() * dash_force # dash
		else:
			if !attack_ip:
				play_animation("run")
			velocity = velocity.lerp(direction.normalized() * speed, acceleration) # smooth acceleration without dash
	else:
		if !attack_ip:
			play_animation("idle")
		velocity = velocity.lerp(Vector2.ZERO, friction) # smooth stop

func dash(): # determine if player can dash and perform dash
	if Input.is_action_just_pressed("dash"):
		if can_dash:
			if !is_dashing:
				is_dashing = true
				dash_duration_timer.start() # dash duration
				can_dash = false
				$Dash.frame = 1
				
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
	$Dash.frame = 0
	
func _on_dash_duration_timeout() -> void: # dash duration
	is_dashing = false
	dash_delay_timer.start()
	
func _on_player_hitbox_body_entered(body: Node2D) -> void: # Détecte quand l'ennemi est à porté
	pass

func _on_player_hitbox_body_exited(body: Node2D) -> void: # Détecte quand l'ennemi n'est plus à porté
	pass
		
func laser_attack():
	current_health = current_health - 50
	global.need_to_take_damage_laser = false
	$animations.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$animations.modulate = Color.WHITE
	
func enemy_attack(): # Détecte quand l'ennemi attaque et enlève les dégâts nécessaires
	if enemy_inattack_range and enemy_attack_cooldown == true :
		print("enemy attack !")
		global.enemy_need_to_attack_anim = true
		current_health = current_health - 10
		$attack_enemis2.play()
		CameraManager.shake(0.4, 0.5, Vector2(50, 50), 0.1)
		
		can_regen = false
		if regen_start_timer.time_left > 0: # timer is active
			regen_start_timer.stop()
			regen_start_timer.start()
		else:
			regen_start_timer.start()
			
		enemy_attack_cooldown = false
		$timers/attack_cooldown.start(0.5)

		$animations.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$animations.modulate = Color.WHITE

func boss_attack():
	print("RECEIVE BOSS ATTACK")
	current_health = current_health - 60
	can_regen = false
	if regen_start_timer.time_left > 0: # timer is active
		regen_start_timer.stop()
		regen_start_timer.start()
	else:
		regen_start_timer.start()
		
	$animations.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	$animations.modulate = Color.WHITE

			
func _on_attack_cooldown_timeout() -> void: # Cooldown de l'attaque
	enemy_attack_cooldown = true

func attack(): # Permet d'attaquer
	if Input.is_action_just_pressed("attack"):
		if can_attack:
			if !is_dashing:
				velocity = Vector2.ZERO
			CameraManager.shake(0.2, 0.2, Vector2(50, 50), 0.1)
			global.player_current_attack = true
			attack_ip = true
			$timers/deal_attack_timer.start(0.5)
			play_animation(random_attack_anim())

func _on_deal_attack_timer_timeout() -> void: # Fin de l'attaque
	$timers/deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false
	can_attack = true

func _on_regen_start_timeout() -> void:
	can_regen = true


func _on_player_hitbox_area_entered(area: Area2D) -> void:
	print(area)
	if area.is_in_group("enemy"):
		enemy_inattack_range = true
		
	if area.is_in_group("boss"):
		is_on_boss_attack_area = true
	if area.is_in_group("attack_hitbox"):
		global.player_can_attack_boss = true

func _on_player_hitbox_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		global.enemy_need_to_attack_anim = false
		enemy_inattack_range = false
		
	if area.is_in_group("boss"):
		is_on_boss_attack_area = false
	if area.is_in_group("attack_hitbox"):
		global.player_can_attack_boss = false


func _on_wait_death_timeout() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/dead_screen.tscn")

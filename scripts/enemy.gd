#extends CharacterBody2D
#
## ANIMATIONS
#@onready var idle_anim: AnimatedSprite2D = $animations/pivot_idle/idle
#@onready var attack_anim: AnimatedSprite2D = $animations/pivot_attack/attack
#@onready var run_anim: AnimatedSprite2D = $animations/pivot_run/run
#@onready var dead_anim: AnimatedSprite2D = $animations/pivot_dead/dead
#
#
#var current_animation : String
#var prev_animation : String
#
#var is_attacking : bool = false
#var alive : bool = true
#
#@export var speed : int = 400
#var player_chase : bool = false
#var player_chase_move : bool = true
#
#var health : int = 100
#var player_inattack_zone = false
#var can_take_damage = true
#
#@export var player : CharacterBody2D
#var DetectionRotation : int = 0
#var can_rotate : bool = true
#var can_scope : bool = true 
	#
#func _ready() -> void:
	#play_animation("idle")
	#
#func _physics_process(delta: float) -> void:
	#Engine.time_scale = 0.1
	#if alive:
		#deal_with_damage()
			#
		#if player_chase:
			#
			#if player_chase_move:
				##if !is_attacking:
				##	play_animation("run")
				#var target_direction = (player.global_position - global_position).normalized()
				#velocity = target_direction * speed
			#else:
				#velocity = Vector2.ZERO
				#
			#position += (player.position - position) / speed
			#$PlayerDetection.look_at(player.global_position)
			#
			#if velocity.x != 0:
				#flip_animation(velocity.x)
					 #
				#
		#else:
			#if !is_attacking:
				#play_animation("idle")
			#velocity = Vector2.ZERO
			#if can_scope:
				#can_scope = false
				#DetectionRotation += 1
				#$PlayerDetection.rotation = DetectionRotation / 2
				#await get_tree().create_timer(0.2).timeout
				#can_scope = true
#
		#if global.enemy_need_to_attack_anim:
			#is_attacking = true
			##global.enemy_need_to_attack_anim = false
			#print("PLAYER ATTACK ANIM")
			#velocity = Vector2.ZERO
			#play_animation("attack")
			#await get_tree().create_timer(1).timeout
			#is_attacking = false
#
			#
	#if health <= 0 && alive:
		#$dye_enemy.play()
		#$Collisions.disabled = true
		#velocity = Vector2.ZERO
		#$PlayerDetection.queue_free()
		#$EnemyHitbox.queue_free()
		#alive = false
		#play_animation("dead")
		#$wait_death.start()
		#
	#move_and_slide()
		#
		#
#func flip_animation(input):
	#var excepted_flip : int
	#
	#
	#for child in $animations.get_children():
		#if input > 0:
			#child.scale.x = -1
		#else:
			#child.scale.x = 1
		#
		#
		#
		#
#func play_animation(animation):
	#if prev_animation == animation:
		#return
	## cache et stop tous les enfants de animations
	#for child in $animations.get_children():
		#for anim_child in child.get_children():
			#anim_child.stop()
			#anim_child.hide()
	#
	#current_animation = animation
	#prev_animation = current_animation
	#print(current_animation)
	#match animation:
		#"dead":
			#dead_anim.show()
			#dead_anim.play("default")
		#"run": 
			#run_anim.show()
			#run_anim.play("default")
		#"attack":
			#attack_anim.show()
			#attack_anim.play("default")
		#"idle":
			#idle_anim.show()
			#idle_anim.play("default")
#
#func _on_player_detection_body_entered(body: Node2D) -> void:
	#
	#if body.has_method("player"):
		#print("ENTRED ", body)
		#if can_rotate:
			#player_chase = true
			#print("CAN")
			#can_rotate = false
			#DetectionRotation += 1
			#$PlayerDetection.rotation = DetectionRotation / 2
			#$RotationDelay.start(0.5)
			#
#func _on_player_detection_body_exited(body: Node2D) -> void:
	#if body.has_method("player"):
		#
		#player_chase = false
		#
#func enemy():
	#pass
#
#func _on_enemy_hitbox_body_entered(body):
	#if body.has_method("player"):
		#print("ENTERED")
		#player_chase_move = false
		#player_inattack_zone = true
#
#
#func _on_enemy_hitbox_body_exited(body):
	#if body.has_method("player"):
		#player_chase_move = true
		#player_inattack_zone = false
#
#func deal_with_damage():
	#if player_inattack_zone == true and global.player_current_attack == true:
		#if can_take_damage == true:
			#
			#health = health - 20
			#$take_damage_cooldown.start()
			#can_take_damage = false
			#
			#
				#
			#$animations.modulate = Color.RED
			#await get_tree().create_timer(0.1).timeout
			#$animations.modulate = Color.WHITE
#
#func _on_take_damage_cooldown_timeout() -> void:
	#can_take_damage = true
#
#
#func _on_rotation_delay_timeout() -> void:
	#can_rotate = true
#
#
#func _on_wait_death_timeout() -> void:
	#self.queue_free()
extends CharacterBody2D

# ANIMATIONS
@onready var idle_anim: AnimatedSprite2D = $animations/pivot_idle/idle
@onready var attack_anim: AnimatedSprite2D = $animations/pivot_attack/attack
@onready var run_anim: AnimatedSprite2D = $animations/pivot_run/run
@onready var dead_anim: AnimatedSprite2D = $animations/pivot_dead/dead

# AUDIO
@onready var die_sound: AudioStreamPlayer = $dye_enemy
@onready var take_damage_timer: Timer = $take_damage_cooldown
@onready var rotation_delay_timer: Timer = $RotationDelay
@onready var death_timer: Timer = $wait_death
@onready var collisions: CollisionShape2D = $Collisions
@onready var player_detection: Area2D = $PlayerDetection
@onready var enemy_hitbox: Area2D = $EnemyHitbox
@onready var animations_node: Node2D = $animations

# STATES
enum EnemyState {
	IDLE,
	CHASING,
	ATTACKING,
	DEAD
}

var current_state: EnemyState = EnemyState.IDLE
var current_animation: String = ""
var prev_animation: String = ""

# COMBAT
@export var max_health: int = 100
var health: int
var can_take_damage: bool = true
var player_in_attack_zone: bool = false
var attack_damage: int = 20
var attack_cooldown: float = 1.0
var is_attacking: bool = false

# MOVEMENT
@export var speed: int = 400
@export var detection_speed: float = 2.0
var player_chase: bool = false
var can_move_to_player: bool = true

# PLAYER REFERENCE
@export var player: CharacterBody2D
var detection_rotation: float = 0.0
var can_rotate: bool = true
var can_scope: bool = true
var detection_range: float = 200.0

# SIGNALS
signal enemy_died
signal player_detected
signal player_lost

func _ready() -> void:
	health = max_health
	change_state(EnemyState.IDLE)
	setup_connections()

func setup_connections() -> void:
	if player_detection:
		player_detection.body_entered.connect(_on_player_detection_body_entered)
		player_detection.body_exited.connect(_on_player_detection_body_exited)
	
	if enemy_hitbox:
		enemy_hitbox.body_entered.connect(_on_enemy_hitbox_body_entered)
		enemy_hitbox.body_exited.connect(_on_enemy_hitbox_body_exited)
	
	if take_damage_timer:
		take_damage_timer.timeout.connect(_on_take_damage_cooldown_timeout)
	
	if rotation_delay_timer:
		rotation_delay_timer.timeout.connect(_on_rotation_delay_timeout)
	
	if death_timer:
		death_timer.timeout.connect(_on_wait_death_timeout)

func _physics_process(delta: float) -> void:
	# Enlever cette ligne qui ralentit le jeu
	# Engine.time_scale = 0.1
	
	match current_state:
		EnemyState.IDLE:
			handle_idle_state()
		EnemyState.CHASING:
			handle_chasing_state()
		EnemyState.ATTACKING:
			handle_attacking_state()
		EnemyState.DEAD:
			handle_dead_state()
	
	# Gérer les dégâts
	if current_state != EnemyState.DEAD:
		deal_with_damage()
	
	# Vérifier la mort
	if health <= 0 and current_state != EnemyState.DEAD:
		change_state(EnemyState.DEAD)
	
	move_and_slide()

func change_state(new_state: EnemyState) -> void:
	current_state = new_state
	
	match new_state:
		EnemyState.IDLE:
			play_animation("idle")
		EnemyState.CHASING:
			play_animation("run")
		EnemyState.ATTACKING:
			play_animation("attack")
		EnemyState.DEAD:
			die()

func handle_idle_state() -> void:
	velocity = Vector2.ZERO
	
	# Rotation de détection
	if can_scope:
		can_scope = false
		detection_rotation += detection_speed
		if player_detection:
			player_detection.rotation_degrees = detection_rotation
		await get_tree().create_timer(0.2).timeout
		if is_inside_tree():
			can_scope = true

func handle_chasing_state() -> void:
	if not player or not is_inside_tree():
		return
	
	if can_move_to_player:
		var target_direction = (player.global_position - global_position).normalized()
		velocity = target_direction * speed
		
		# Flip l'animation selon la direction
		if velocity.x != 0:
			flip_animation(velocity.x)
	else:
		velocity = Vector2.ZERO
	
	# Regarder vers le joueur
	if player_detection:
		player_detection.look_at(player.global_position)
	
	# Vérifier si on doit attaquer
	if player_in_attack_zone and not is_attacking:
		change_state(EnemyState.ATTACKING)

func handle_attacking_state() -> void:
	if not is_attacking:
		start_attack()

func handle_dead_state() -> void:
	velocity = Vector2.ZERO

func start_attack() -> void:
	is_attacking = true
	velocity = Vector2.ZERO
	play_animation("attack")
	
	# Attendre la fin de l'animation d'attaque
	await get_tree().create_timer(attack_cooldown).timeout
	
	if is_inside_tree():
		is_attacking = false
		
		# Retourner à l'état approprié
		if player_chase:
			change_state(EnemyState.CHASING)
		else:
			change_state(EnemyState.IDLE)

func flip_animation(input: float) -> void:
	if not animations_node:
		return
		
	for child in animations_node.get_children():
		if input > 0:
			child.scale.x = -1
		else:
			child.scale.x = 1

func play_animation(animation: String) -> void:
	if prev_animation == animation or not animations_node:
		return
	
	# Cacher et arrêter toutes les animations
	for child in animations_node.get_children():
		for anim_child in child.get_children():
			if anim_child is AnimatedSprite2D:
				anim_child.stop()
				anim_child.hide()
	
	current_animation = animation
	prev_animation = current_animation
	
	# Jouer l'animation demandée
	match animation:
		"dead":
			if dead_anim:
				dead_anim.show()
				dead_anim.play("default")
		"run": 
			if run_anim:
				run_anim.show()
				run_anim.play("default")
		"attack":
			if attack_anim:
				attack_anim.show()
				attack_anim.play("default")
		"idle":
			if idle_anim:
				idle_anim.show()
				idle_anim.play("default")

func die() -> void:
	if die_sound:
		die_sound.play()
	
	if collisions:
		collisions.disabled = true
	
	velocity = Vector2.ZERO
	
	# Nettoyer les composants
	if player_detection:
		player_detection.queue_free()
	if enemy_hitbox:
		enemy_hitbox.queue_free()
	
	play_animation("dead")
	
	if death_timer:
		death_timer.start()
	
	enemy_died.emit()

func take_damage(damage: int) -> void:
	if not can_take_damage or current_state == EnemyState.DEAD:
		return
	
	health = max(0, health - damage)
	can_take_damage = false
	
	if take_damage_timer:
		take_damage_timer.start()
	
	# Effet visuel de dégâts
	show_damage_effect()

func show_damage_effect() -> void:
	if not animations_node:
		return
		
	animations_node.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	
	if is_inside_tree() and animations_node:
		animations_node.modulate = Color.WHITE

func deal_with_damage() -> void:
	if player_in_attack_zone and global.player_current_attack:
		take_damage(attack_damage)

# SIGNAL HANDLERS
func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.has_method("player") and current_state != EnemyState.DEAD:
		player_chase = true
		change_state(EnemyState.CHASING)
		player_detected.emit()
		
		if can_rotate:
			can_rotate = false
			detection_rotation += 10
			if player_detection:
				player_detection.rotation_degrees = detection_rotation
			if rotation_delay_timer:
				rotation_delay_timer.start(0.5)

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_chase = false
		change_state(EnemyState.IDLE)
		player_lost.emit()

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player") and current_state != EnemyState.DEAD:
		can_move_to_player = false
		player_in_attack_zone = true

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		can_move_to_player = true
		player_in_attack_zone = false

func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true

func _on_rotation_delay_timeout() -> void:
	can_rotate = true

func _on_wait_death_timeout() -> void:
	queue_free()

# MÉTHODES UTILITAIRES
func enemy() -> void:
	pass

func get_health_percentage() -> float:
	return float(health) / float(max_health)

func is_player_in_range() -> bool:
	if not player:
		return false
	return global_position.distance_to(player.global_position) <= detection_range

func reset_enemy() -> void:
	health = max_health
	can_take_damage = true
	player_in_attack_zone = false
	is_attacking = false
	player_chase = false
	can_move_to_player = true
	change_state(EnemyState.IDLE)

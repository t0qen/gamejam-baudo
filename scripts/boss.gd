extends CharacterBody2D

@export var player : CharacterBody2D 
@onready var health_bar: ProgressBar = $health_bar
@export var HEALTH : int = 1000

# ANIMATION
@onready var combat_1_anim: AnimatedSprite2D = $animation/combat1/combat1
@onready var combat_2_anim: AnimatedSprite2D = $animation/combat2/combat2
@onready var idle_anim: AnimatedSprite2D = $animation/idle/idle
var current_animation : String
var prev_animation : String


var is_cycle_started : bool = false

var excepted_combat
var cb1_excepted_left_frame = 55
var cb1_excepted_right_frame = 15
var cb2_excepted_frame = 100

var current_health : int = HEALTH
var can_attack : bool = false
var is_attacking : bool = false
var is_player_near : bool = false
var can_take_damage : bool = true
var current_attack : int 

var is_dead : bool = false

enum PHASE {
	CB1,
	CB2,
	IDLE
}
var current_phase : PHASE

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if is_cycle_started:
		update_phase()
			
			
		receive_attack()
		update_health_bar()
		#print(current_health)
		if current_health <= 0:
			is_dead = true
			is_cycle_started = false


func start_cycle():
	current_phase = PHASE.CB1
	is_cycle_started = true
	play_animation("idle")
	$switch_phase.start()
	


func update_phase():
	match current_phase:
		PHASE.IDLE:
			play_animation("idle")
			$Label.text = "INACTIF, METS LE PLUS DE DEGAT"
		PHASE.CB1:
			play_animation("combat1")
			setup_att1()
			$Label.text = "PHASE 1"
		PHASE.CB2:
			play_animation("combat2")
			setup_att1_cb2()
			$Label.text = "PHASE 2"
	
func setup_att1_cb2():
	var current_frame = $animation/combat2/combat2.frame 
	if current_frame == cb2_excepted_frame:
		attack1_cb2()
	
func attack1_cb2(): #
	if !is_attacking:
		is_attacking = true
		global.player_attacked_by_boss = true
		$cb2_attack/attack.show()
		$cb2_attack/attack.play("default")
		$cb2_attack_hitbox/CollisionShape2D.disabled = false
		#$right_attack.hide()
		#$left_attack.hide()
		#var excepted_side # 1: gauche 2: droite
		#$left_attack.look_at(player.global_position)
		#$right_attack.look_at(player.global_position)
		#await get_tree().create_timer(0.5).timeout
		#$left_attack.show()
		#$right_attack.show()
		#$left_attack.get_child(0).play("default")
		#$right_attack.get_child(0).play("default")
		await get_tree().create_timer(0.5).timeout
		$cb2_attack_hitbox/CollisionShape2D.disabled = true
		$cb2_attack/attack.hide()
		global.player_attacked_by_boss = false
		is_attacking = false
		
func setup_att1():
	var current_frame = $animation/combat1/combat1.frame 
	
	if current_frame == cb1_excepted_left_frame:
		attack1(1)
	if current_frame == cb1_excepted_right_frame:
		attack1(2)

	
func attack1(mode): # attaque vient que d'un coté à la fois
	if !is_attacking:
		is_attacking = true
		
		var excepted_side # 1: gauche 2: droite
		var current_attack_side
		if mode == 1: # mode = quel coté on attaque 1: gauche 2: droite
			$right_attack.hide()
			current_attack_side = $left_attack
			$left_attack/hitbox/CollisionShape2D.disabled = false
			
		elif mode == 2:
			$left_attack.hide()
			current_attack_side = $right_attack
			$right_attack/hitbox2/CollisionShape2D.disabled = false
			
		current_attack_side.look_at(player.global_position)
		await get_tree().create_timer(0.5).timeout
		global.player_attacked_by_boss = true
		current_attack_side.show()
		current_attack_side.get_child(0).play("default")
		await get_tree().create_timer(0.5).timeout
		$left_attack/hitbox/CollisionShape2D.disabled = true
		$right_attack/hitbox2/CollisionShape2D.disabled = true
		global.player_attacked_by_boss = false
		is_attacking = false
	
	
func play_animation(animation):
	if prev_animation == animation:
		return
	# cache et stop tous les enfants de animations
	for child in $animation.get_children():
		for anim_child in child.get_children():
			anim_child.stop()
			anim_child.hide()
	
	current_animation = animation
	prev_animation = current_animation
	match animation:
		"combat1":
			combat_1_anim.show()
			combat_1_anim.play("default")
		"combat2":
			combat_2_anim.show()
			combat_2_anim.play("default")
		"idle":
			idle_anim.show()
			idle_anim.play("default")
		
			
			
func update_health_bar():
	health_bar.value = current_health
	
func receive_attack():
	if global.player_can_attack_boss == true && global.player_current_attack == true:
		if can_take_damage:
			can_take_damage = false
			current_health = current_health - 10
			await get_tree().create_timer(0.75).timeout
			can_take_damage = true
		
func attack_player(attack):
	if can_attack:
		can_attack = false
		if attack == 1: # attaque que de un coté
			var excepted_side # 1: gauche 2: droite
			var current_attack_side
			if player.global_position.x < global_position.x:
				excepted_side = 1 
				$right_attack.hide()
				current_attack_side = $left_attack
			else:
				excepted_side = 2
				$left_attack.hide()
				current_attack_side = $right_attack
				
			current_attack_side.show()
			current_attack_side.look_at(player.global_position)
		
		#if node_a.position.x < node_b.position.x:
			#print("node_a est à gauche de node_b")
		#else:
			#print("node_a est à droite de node_b")
			
		#if attack == 1:
			#$Node2D.look_at(player.global_position)
			#await get_tree().create_timer(0.3).timeout
		#
			#$Node2D.show()
			#CameraManager.shake(0.7, 1.5, Vector2(50, 50), 0.5)
			#is_attacking = true
			#attack_duration.start()
		#elif attack == 2:
			#pass
		
	else:
		return


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("ENTERED")
	print(body.get_groups())
	if body.has_method("player"):
		print("PLAYER")
		if is_attacking:
			print("ATTACK")
			
			#player.boss_attack()

func is_boss_attacking():
	return is_attacking
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	print("EXITED")

func boss():
	pass

func _on_receive_attack_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		is_player_near = true
		
func _on_receive_attack_hitbox_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		is_player_near = false


func _on_switch_phase_timeout() -> void:
	print("CHANGE PHASE")
	match current_phase :
		PHASE.IDLE:
			current_phase = PHASE.CB1
		PHASE.CB1:
			$right_attack.hide()
			$left_attack.hide()
			current_phase = PHASE.CB2
		PHASE.CB2:
			$cb2_attack/attack.hide()
			current_phase = PHASE.IDLE
		
		

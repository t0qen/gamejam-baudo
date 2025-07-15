extends CharacterBody2D

@export var player : CharacterBody2D 
@onready var attack_delay: Timer = $attack_delay
@onready var attack_duration: Timer = $attack_duration
@onready var health_bar: ProgressBar = $health_bar

@export var HEALTH : int = 500
var current_health : int = HEALTH
var can_attack : bool = false
var is_attacking : bool = false
var is_player_near : bool = false
var can_take_damage : bool = true

func _ready() -> void:
	attack_delay.start()
	$Node2D.hide()
	
func _physics_process(delta: float) -> void:
	
	if player:
		attack_player()
		$Icon2.look_at(player.global_position)
		
	print(" is near ?", global.player_can_attack_boss)
	print("can attack ?", global.player_current_attack)
	receive_attack()
	update_health_bar()
	print(current_health)
	if current_health <= 0:
		
		self.queue_free()
		
		
func update_health_bar():
	health_bar.value = current_health
	
func receive_attack():
	if global.player_can_attack_boss == true && global.player_current_attack == true:
		if can_take_damage:
			print("PLAYER ATTACK")
			can_take_damage = false
			current_health = current_health - 25 
			await get_tree().create_timer(0.5).timeout
			can_take_damage = true
		
func attack_player():
	if can_attack:
		can_attack = false
		$Node2D.look_at(player.global_position)
		await get_tree().create_timer(0.3).timeout
		
		$Node2D.show()
		
		is_attacking = true
		attack_duration.start()
		
	else:
		return

func _on_attack_delay_timeout() -> void:
	can_attack = true


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
	
func _on_attack_duration_timeout() -> void:
	attack_delay.start()
	is_attacking = false
	$Node2D.hide()

func boss():
	pass

func _on_receive_attack_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		is_player_near = true
		
func _on_receive_attack_hitbox_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		is_player_near = false

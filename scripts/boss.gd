extends CharacterBody2D

@export var player : CharacterBody2D 
@onready var attack_delay: Timer = $attack_delay
@onready var attack_duration: Timer = $attack_duration

var can_attack : bool = false
var is_attacking : bool = false

func _ready() -> void:
	attack_delay.start()
	$Node2D.hide()
	
func _physics_process(delta: float) -> void:
	
	if player:
		attack_player()
		$Icon2.look_at(player.global_position)
		
		
		
func attack_player():
	if can_attack:
		$Node2D.look_at(player.global_position)
		await get_tree().create_timer(0.5).timeout
		
		$Node2D.show()
		can_attack = false
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
			player.boss_attack()

func _on_area_2d_body_exited(body: Node2D) -> void:
	print("EXITED")
	
func _on_attack_duration_timeout() -> void:
	attack_delay.start()
	is_attacking = false
	$Node2D.hide()

func boss():
	pass

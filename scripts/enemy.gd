extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var speed : float = 100
var player_chase : bool = false
var player = null

var health : int = 100
var player_inattack_zone = false
var can_take_damage = true

func _physics_process(delta: float) -> void:
	deal_with_damage()
	
	if player_chase:
		print("PLAYER CHASE")
		position += (player.position - position) / speed
		
		if(player.position.x - position.x) < 0:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false


func _on_player_detection_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_player_detection_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
	
func enemy():
	pass


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		print("body enterred")
		player_inattack_zone = true


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		print("body exit")
		player_inattack_zone = false

func deal_with_damage():
	if player_inattack_zone == true and global.player_current_attack == true:
		if can_take_damage == true:
			health = health - 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("slime health = ", health)
			if health <= 0:
				self.queue_free()


func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true

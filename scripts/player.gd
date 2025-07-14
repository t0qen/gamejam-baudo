extends CharacterBody2D

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

func _physics_process(delta):
	
	var input = Input.get_vector("move_left","move_right","move_up","move_down")
	player_movement(input, delta)
	
	if Input.is_action_pressed("move_left") and direction == 1:
		animated_sprite_2d.flip_h = true
		direction = -1
	elif Input.is_action_just_pressed("move_right") and direction == -1:
		animated_sprite_2d.flip_h = false
		direction = 1
	
	move_and_slide()

extends CharacterBody2D

# /* VARIABLES */
# TIMERS
@onready var dash_duration_timer: Timer = $timers/dash_duration
@onready var dash_delay_timer: Timer = $timers/dash_delay

# MOVEMENTS
@export var speed = 400
@export var friction = 0.5
@export var acceleration = 0.5

var can_dash : bool = true
var is_dashing : bool = false
@export var dash_force : int = 2000

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
		if is_dashing:
			velocity = direction.normalized() * dash_force # smooth acceleration without dash
		else:
			velocity = velocity.lerp(direction.normalized() * speed, acceleration) # smooth acceleration without dash
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction) # smooth stop

func dash(): # determine if player can dash and perform dash
	if Input.is_action_just_pressed("dash"):
		if can_dash:
			if !is_dashing:
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
		
# SIGNALS
func _on_dash_delay_timeout() -> void: # delay when player can't dash
	print("DASH DELAY FINISHED")
	can_dash = true

func _on_dash_duration_timeout() -> void: # dash duration
	print("DASH FINISHED")
	is_dashing = false
	dash_delay_timer.start()

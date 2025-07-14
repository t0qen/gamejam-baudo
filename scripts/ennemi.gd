extends CharacterBody2D

@onready var target: CharacterBody2D = %Player

var speed = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var direction = (target.position-position)
	velocity = direction * speed
	move_and_slide()

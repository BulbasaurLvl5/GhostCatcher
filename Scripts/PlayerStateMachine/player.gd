class_name Player
extends CharacterBody2D


@export var walk_speed = 40.0
@export var walk_acceleration = 50.0
@export var run_speed = 70.0
@export var run_acceleration = 80.0
@export var jump_velocity = -100.0
@export var in_air_speed = 50.0
@export var gravity = 500.0
@export var facing_direction = 1

@onready var input_direction = Vector2.ZERO
@onready var is_grounded = true
@onready var is_exiting_state = false

func _process(delta):
	input_direction = Input.get_vector("Left", "Right", "Up", "Down").round()
	if facing_direction != input_direction.x && input_direction.x != 0:
		facing_direction = input_direction.x
		scale.x *= -1
	$GroundCheck.force_raycast_update()
	is_grounded = $GroundCheck.is_colliding()
	print("grounded ... ",is_grounded)

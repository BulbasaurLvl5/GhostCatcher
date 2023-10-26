class_name Player
extends CharacterBody2D

@export var verbose: bool = false
@export var facing_direction: int = 1

@onready var x_input: int = 0
@onready var y_input: int = 0
@onready var is_grounded: bool
@onready var can_jump: bool

func _process(delta):
	#input checks
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down").round()
	x_input = input_direction.x
	y_input = input_direction.y
	if !can_jump && !Input.is_action_pressed("Jump"):
		can_jump = true
	
	#environmental checks
	$PlayerSprite2D/GroundCheck.force_raycast_update()
	$PlayerSprite2D/GroundCheck2.force_raycast_update()	
	is_grounded = max(int($PlayerSprite2D/GroundCheck.is_colliding()), int($PlayerSprite2D/GroundCheck2.is_colliding()))
	
#	if verbose:
#		print($GroundCheck.is_colliding(),$GroundCheck2.is_colliding(),is_grounded)

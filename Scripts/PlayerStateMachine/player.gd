class_name Player
extends CharacterBody2D

@export var facing_direction = 1

@onready var x_input = 0
@onready var y_input = 0
@onready var is_grounded = true
@onready var is_exiting_state = false

func _process(delta):
	#input checks
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down").round()
	x_input = input_direction.x
	y_input = input_direction.y
	#environmental checks
	$GroundCheck.force_raycast_update()
	$GroundCheck2.force_raycast_update()	
	is_grounded = max(int($GroundCheck.is_colliding()), int($GroundCheck2.is_colliding()))
	#print($GroundCheck.is_colliding(),$GroundCheck2.is_colliding(),is_grounded)

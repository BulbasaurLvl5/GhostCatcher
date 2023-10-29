class_name Player
extends CharacterBody2D

@export var verbose : bool = false
@export var facing_direction : int = 1
@export var max_air_actions : int = 2

@onready var x_input : int = 0
@onready var y_input : int = 0
@onready var input_direction : Vector2 = Vector2.ZERO
@onready var is_grounded : bool
@onready var can_touch_wall : bool
@onready var is_facing_wall : bool
@onready var remaining_air_actions : int = max_air_actions
@onready var last_touched_wall : bool = false
@onready var jump_button_reset : bool = false
@onready var dash_button_reset : bool = false

func _process(delta):
	#input checks
	input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	x_input = round(input_direction.x)
	y_input = round(input_direction.y)
	if verbose && (Input.is_action_pressed("Left") || Input.is_action_pressed("Right")) && x_input == 0:
		print("X INPUT IS NOT REGISTERING!!!")
	if !jump_button_reset && !Input.is_action_pressed("Jump"):
		jump_button_reset = true
	if !dash_button_reset && !Input.is_action_pressed("Dash"):
		dash_button_reset = true
		
	#environmental checks
	$PlayerSprite2D/GroundCheckFront.force_raycast_update()	
	$PlayerSprite2D/GroundCheckBack.force_raycast_update()
	$PlayerSprite2D/WallCheckShoulder.force_raycast_update()
	$PlayerSprite2D/WallCheckToe.force_raycast_update()
	
	is_grounded = max(int($PlayerSprite2D/GroundCheckFront.is_colliding()), int($PlayerSprite2D/GroundCheckBack.is_colliding()))
	can_touch_wall = int($PlayerSprite2D/WallCheckShoulder.is_colliding())
	is_facing_wall = max(int(can_touch_wall), int($PlayerSprite2D/WallCheckToe.is_colliding()))
		
	if is_grounded:
		remaining_air_actions = max_air_actions
		last_touched_wall = false

func can_jump() -> bool:
	if !jump_button_reset:
		return false
	if is_grounded || remaining_air_actions > 0 || !$CoyoteTime.is_stopped():
		return true
	else:
		return false

func can_dash() -> bool:
	if !dash_button_reset:
		return false
	if is_grounded || remaining_air_actions > 0 || !$CoyoteTime.is_stopped():
		return true
	else:
		return false
		
func air_action():
	if $CoyoteTime.is_stopped():
		remaining_air_actions -= 1

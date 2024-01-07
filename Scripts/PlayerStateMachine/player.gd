class_name Player
extends CharacterBody2D


#level-dependent parameters
@export var facing_direction : int = 1
@export var cast : ShapeCast2D
@export var grab_cast : ShapeCast2D

#development settings
@export var verbose : bool = false
@export var data : PlayerDataResource 

var x_input : int = 0
var y_input : int = 0
var jump_input : bool = false
var jump_button_reset : bool = true
var dash_input : bool = false
var dash_button_reset : bool = true
var last_dash_time : float
#var input_direction : Vector2 = Vector2.ZERO
var was_grounded : bool
var could_grab_wall : bool
var is_grabbing_wall : bool = false

@onready var remaining_air_actions : int = data.max_air_actions
#@onready var camera : Camera = %Camera2D


func _ready():
	if !cast && %ShapeCast2D:
		cast = %ShapeCast2D
	if !grab_cast && %GrabShapeCast2D:
		grab_cast = %GrabShapeCast2D


func _process(_delta):
	check_input()
	check_environment()


func check_input():
	x_input = 0
	y_input = 0
	if Input.is_action_pressed("Left1") || Input.is_action_pressed("Left2"):
		x_input -= 1
	if Input.is_action_pressed("Right1") || Input.is_action_pressed("Right2"):
		x_input += 1
	if Input.is_action_pressed("Up1") || Input.is_action_pressed("Up2"):
		y_input -= 1
	if Input.is_action_pressed("Down1") || Input.is_action_pressed("Down2"):
		y_input += 1
		
	if Input.is_action_pressed("Jump1") || Input.is_action_pressed("Jump2"):
		jump_input = true
	else:
		jump_input = false
		if !jump_button_reset:
			jump_button_reset = true
	if Input.is_action_pressed("Dash1") || Input.is_action_pressed("Dash2"):
		dash_input = true	
	else:
		dash_input = false
		if !dash_button_reset:
			dash_button_reset = true

	if Input.is_action_pressed("Zoom1") || Input.is_action_pressed("Zoom2"):
		%Camera2D.camera_zoom(true)
	else:
		%Camera2D.camera_zoom(false)

	
func check_environment():
	was_grounded = is_grounded()
	could_grab_wall = can_grab_wall()
	
func is_grounded() -> bool:
	if get_collisions(Vector2.DOWN * 2):
		remaining_air_actions = data.max_air_actions
		return true
	else:
		return false

func can_grab_wall() -> bool:
	if get_collisions(Vector2(facing_direction * 10, 0), grab_cast) && x_input == facing_direction:
		return true
	else:
#		if !get_collisions(Vector2(facing_direction, 0), grab_cast) && x_input == facing_direction:
#			print("cannot wall grab because no wall detected")
		return false

func can_jump() -> bool:
	if !jump_input || !jump_button_reset:
		return false
	if !$CoyoteTime.is_stopped() || remaining_air_actions > 0 || is_grounded():
		return true
	else:
		return false

func can_dash() -> bool:
	if !dash_input || !dash_button_reset:
		return false
	if !$CoyoteTime.is_stopped() || remaining_air_actions > 0:
		return true
	if is_grounded() && last_dash_time + data.ground_dash_cooldown < Time.get_unix_time_from_system():
		return true
	else:
		return false

func air_action():
	if $CoyoteTime.is_stopped():
		remaining_air_actions -= 1

func stop_motion():
	velocity = Vector2.ZERO
	move_and_slide()


func get_collisions(offset : Vector2 = Vector2.ZERO, shape_cast : ShapeCast2D = cast) -> Array:
	var array : Array = []
	shape_cast.position += offset
	shape_cast.force_shapecast_update()
	if shape_cast.is_colliding():
		var total = shape_cast.get_collision_count()
		var count = 0
		while count < total:
			array.append(shape_cast.get_collider(count))
			count += 1
	if shape_cast == cast:
		cast.position = Vector2.ZERO
	else:
		shape_cast.position -= offset
	return array

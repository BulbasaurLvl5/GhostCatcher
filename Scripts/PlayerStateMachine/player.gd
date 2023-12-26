class_name Player
extends Actor


#level-dependent parameters
@export var facing_direction : int = 1
@export var wall_grab_shape_cast : ShapeCast2D

#development settings
@export var verbose : bool = false
@export var player_data_resources : Array[PlayerDataResource]
@export var data : PlayerDataResource 

#player status
var x_input : int = 0
var y_input : int = 0
var jump_input : bool = false
var dash_input : bool = false
var input_direction : Vector2 = Vector2.ZERO
var is_grounded : bool
var can_touch_wall : bool
var is_facing_wall : bool
var wall_is_behind : bool
var last_touched_wall : bool = false
var jump_button_reset : bool = true
var dash_button_reset : bool = true
var last_dash_time : float
var prev_player_data_button_reset : bool = true
var next_player_data_button_reset : bool = true
var command_list_button_reset : bool = true
var current_player_data_preset : int = 0
var is_grabbing_wall : bool = false

@onready var remaining_air_actions : int = data.max_air_actions


func _ready():
	if data == null:
		data = player_data_resources[0]
		current_player_data_preset = 0
	print("PlayerData set to: ",data.player_data_name_or_description)
	print("Press '0' (zero) to see a list of available commands.")


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
		
	jump_input = false
	dash_input = false
	if Input.is_action_pressed("Jump1") || Input.is_action_pressed("Jump2"):
		jump_input = true
	if Input.is_action_pressed("Dash1") || Input.is_action_pressed("Dash2"):
		dash_input = true	
	if !jump_button_reset && !jump_input:
		jump_button_reset = true
	if !dash_button_reset && !dash_input:
		dash_button_reset = true
		
	if !command_list_button_reset && !Input.is_action_pressed("CommandList"):
		command_list_button_reset = true
	if !prev_player_data_button_reset && !Input.is_action_pressed("PrevPlayerDataPreset"):
		prev_player_data_button_reset = true
	if !next_player_data_button_reset && !Input.is_action_pressed("NextPlayerDataPreset"):
		next_player_data_button_reset = true
	if command_list_button_reset && Input.is_action_pressed("CommandList"):
		show_command_list()
	if prev_player_data_button_reset && Input.is_action_pressed("PrevPlayerDataPreset"):
		prev_player_data_preset()
	if next_player_data_button_reset && Input.is_action_pressed("NextPlayerDataPreset"):
		next_player_data_preset()
	

func check_environment():
	var collisions : Array = []
	if moving_platform == null:	
		collisions = get_collisions(Vector2.DOWN)
	else:
		collisions = get_collisions(Vector2(0, 10))
		
	if collisions:
		is_grounded = true
		moving_platform = check_platform(collisions)
#		print("ON MOVING PLATFORM")
	else:
		is_grounded = false

	if get_collisions(Vector2((facing_direction * 2), 0)):
		is_facing_wall = true
		if is_grabbing_wall:
			moving_platform = check_platform(collisions)
	else:
		is_facing_wall = false
	
#	if verbose:
#		print("Can touch wall is ",can_touch_wall," and WG shapecast is @ ",wall_grab_shape_cast.position)
	if wall_grab_shape_cast.is_colliding():
#		if verbose && !can_touch_wall:
#			print("CAN TOUCH WALL BECAUSE WG shape cast is colliding:")
#		var count = wall_grab_shape_cast.get_collision_count()
#		while count > 0:
#			print("wall grab shape cast detects:        ",wall_grab_shape_cast.get_collider(count - 1))
#			count -= 1
		can_touch_wall = true
	else:
#		if verbose:
#			print("can't touch wall")
		can_touch_wall = false
	
	if is_grounded:
		remaining_air_actions = data.max_air_actions
		last_touched_wall = false


func check_platform(collisions) -> MovingObject:
	for c in collisions:
		if c is MovingObject:
			return c
	return null


func approach_moving_object(object : MovingObject, range : Vector2):
	if moving_platform == object:
		return
#	if verbose:
#		print("APPROACHING MOVING OBJECT")

	if range.y > 0:
#		if verbose && moving_platform != object:
#			print("Player found MOVING OBJECT ",object)
		moving_platform = object
		var step = sign(range.y)
		var count = range.y
		while count > 0:
			if get_collisions(Vector2(0, step * count)) == null:
				position.y += (step * count) 
				%PlayerState.Transitioned.emit(self,"Land")
				return
			count -= 1
	elif range.y < 0:
		%PlayerState.Transitioned.emit(self,"InAir")
	else:
		moving_platform = object
		var step = sign(range.x)
		var count = abs(range.x)
		while count > 0:
			wall_grab_shape_cast.position.x += step
			wall_grab_shape_cast.force_shapecast_update()
			if wall_grab_shape_cast.is_colliding() == null:
				wall_grab_shape_cast.position.x = 50
				position.x += step * count
				if verbose:
					print("grabbing wall from PLAYER")
				%PlayerState.Transitioned.emit(self,"WallGrab")
				return
			count -= 1
		wall_grab_shape_cast.position.x = 50


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


func show_command_list():
	command_list_button_reset = false
	print("")
	print("AWSD/arrows  Move")
	print("      space  Jump")
	print("      enter  Dash")
#	print("      shift  Grab Wall")
#	print("      shift  Move Slower")
	print("")
	print("          0  Show Command List")
	print("          9  Revive/Die")
	print("          -  Toggle Player Verbosity")
	print("    page up  Prev PlayerData Preset")
	print("  page down  Next PlayerData Preset")


func prev_player_data_preset():
	current_player_data_preset -= 1
	if current_player_data_preset < 0:
		current_player_data_preset = player_data_resources.size()-1
	data = player_data_resources[current_player_data_preset]
	print("New player_data_resource: ",current_player_data_preset," - ",data.player_data_name_or_description)
	prev_player_data_button_reset = false


func next_player_data_preset():
	current_player_data_preset += 1
	if current_player_data_preset > player_data_resources.size()-1:
		current_player_data_preset = 0
	data = player_data_resources[current_player_data_preset]
	print("New player_data_resource: ",current_player_data_preset," - ",data.player_data_name_or_description)
	next_player_data_button_reset = false

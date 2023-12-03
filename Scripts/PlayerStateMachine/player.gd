class_name Player
extends CharacterBody2D


#level-dependent parameters
@export var facing_direction : int = 1

#development settings
@export var verbose : bool = false
@export var player_data_resources : Array[PlayerDataResource]
@export var data : PlayerDataResource 

#player status
@onready var x_input : int = 0
@onready var y_input : int = 0
@onready var input_direction : Vector2 = Vector2.ZERO
@onready var is_grounded : bool
@onready var can_touch_wall : bool
@onready var is_facing_wall : bool
@onready var wall_is_behind : bool
@onready var remaining_air_actions : int = data.max_air_actions
@onready var last_touched_wall : bool = false
@onready var jump_button_reset : bool = true
@onready var dash_button_reset : bool = true
@onready var last_dash_time : float
@onready var prev_player_data_button_reset : bool = true
@onready var next_player_data_button_reset : bool = true
@onready var command_list_button_reset : bool = true
@onready var current_player_data_preset = 0
@onready var is_on_moving_platform : bool = false
@onready var ground : Node
@onready var attached_platform : Node
@onready var movement_adjustment : Vector2 = Vector2.ZERO


func _ready():
	if data == null:
		data = player_data_resources[0]
		current_player_data_preset = 0
	print("PlayerData set to: ",data.player_data_name_or_description)
	print("Press '0' (zero) to see a list of available commands.")


func _process(_delta):
	#input checks
	x_input = int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left"))
	y_input = int(Input.is_action_pressed("Down")) - int(Input.is_action_pressed("Up"))
#	if verbose:
#		print(input_direction," turned into ",x_input,y_input)
	if !jump_button_reset && !Input.is_action_pressed("Jump"):
		jump_button_reset = true
	if !dash_button_reset && !Input.is_action_pressed("Dash"):
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
	
	#environmental checks
	$PlayerAnimatedSprite2D/WallCheckShoulder.force_raycast_update()
	$PlayerAnimatedSprite2D/WallCheckToe.force_raycast_update()
	$PlayerAnimatedSprite2D/WallCheckBack.force_raycast_update()
		
	can_touch_wall = int($PlayerAnimatedSprite2D/WallCheckShoulder.is_colliding())
	wall_is_behind = int($PlayerAnimatedSprite2D/WallCheckBack.is_colliding())
	is_facing_wall = max(int(can_touch_wall), int($PlayerAnimatedSprite2D/WallCheckToe.is_colliding()))
	
	$PlayerAnimatedSprite2D/GroundCheckFront.force_raycast_update()	
	$PlayerAnimatedSprite2D/GroundCheckBack.force_raycast_update()
	$PlayerAnimatedSprite2D/StickyGroundCheckFront.force_raycast_update()	
	$PlayerAnimatedSprite2D/StickyGroundCheckBack.force_raycast_update()
	#set is_grounded (and ground if applies)
	if $PlayerAnimatedSprite2D/GroundCheckFront.is_colliding() && !is_facing_wall:
		ground = ($PlayerAnimatedSprite2D/GroundCheckFront.get_collider())
		examine_ground()
	elif $PlayerAnimatedSprite2D/GroundCheckBack.is_colliding() && !wall_is_behind:
		ground = ($PlayerAnimatedSprite2D/GroundCheckBack.get_collider())
		examine_ground()
	else:
		is_grounded = false
		if !is_above_sticky_ground():
			if is_on_moving_platform:
				unlink_from_moving_platform()
	
		
	if is_grounded:
		remaining_air_actions = data.max_air_actions
		last_touched_wall = false


func examine_ground():
	is_grounded = true
	if is_above_sticky_ground():
		examine_sticky_ground()
	elif is_on_moving_platform:
		unlink_from_moving_platform()


func is_above_sticky_ground() -> bool:
	if $PlayerAnimatedSprite2D/StickyGroundCheckFront.is_colliding():
		ground = ($PlayerAnimatedSprite2D/StickyGroundCheckFront.get_collider())
		return true
	elif $PlayerAnimatedSprite2D/StickyGroundCheckBack.is_colliding():
		ground = ($PlayerAnimatedSprite2D/StickyGroundCheckBack.get_collider())
		return true
	else:
		return false
		
		
func examine_sticky_ground():
	if ground.type == ("MovingPlatform") && !is_on_moving_platform:
		link_to_moving_platform(ground)
		
		
func link_to_moving_platform(node: Node):
	attached_platform = node
	attached_platform.Moving.connect(adjust_movement)
	is_on_moving_platform = true
	if verbose:
		print(self.name," linking to ",attached_platform)


func unlink_from_moving_platform():
	is_on_moving_platform = false
	attached_platform.Moving.disconnect(adjust_movement)
	if verbose:
		print(self.name," unlinking from ",attached_platform)
	
	
func adjust_movement(motion : Vector2):
	movement_adjustment += motion


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

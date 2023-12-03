class_name Player
extends CharacterBody2D


#level-dependent parameters
@export var facing_direction : int = 1

#development settings
@export var verbose : bool = false
@export var using_stefan_screen_size : bool = true
@export var stefan_screen_size : Vector2i = Vector2i(1152,648)
@export var daniel_screen_size : Vector2i = Vector2i(1920,1080)
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
@onready var screen_size_button_reset : bool = true
@onready var current_player_data_preset = 0


func _ready():
	if data == null:
		data = player_data_resources[0]
		current_player_data_preset = 0
	set_screen_size(false)
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
	if !screen_size_button_reset && !Input.is_action_pressed("ScreenSize"):
		screen_size_button_reset = true
	if Input.is_action_pressed("ScreenSize"):
		set_screen_size(true)
	if command_list_button_reset && Input.is_action_pressed("CommandList"):
		show_command_list()
	if prev_player_data_button_reset && Input.is_action_pressed("PrevPlayerDataPreset"):
		prev_player_data_preset()
	if next_player_data_button_reset && Input.is_action_pressed("NextPlayerDataPreset"):
		next_player_data_preset()
	
	#environmental checks
	$PlayerAnimatedSprite2D/GroundCheckFront.force_raycast_update()	
	$PlayerAnimatedSprite2D/GroundCheckBack.force_raycast_update()
	$PlayerAnimatedSprite2D/WallCheckShoulder.force_raycast_update()
	$PlayerAnimatedSprite2D/WallCheckToe.force_raycast_update()
	$PlayerAnimatedSprite2D/WallCheckBack.force_raycast_update()
		
	can_touch_wall = int($PlayerAnimatedSprite2D/WallCheckShoulder.is_colliding())
	wall_is_behind = int($PlayerAnimatedSprite2D/WallCheckBack.is_colliding())
	is_facing_wall = max(int(can_touch_wall), int($PlayerAnimatedSprite2D/WallCheckToe.is_colliding()))
	if ($PlayerAnimatedSprite2D/GroundCheckFront.is_colliding() && !is_facing_wall) || ($PlayerAnimatedSprite2D/GroundCheckBack.is_colliding() && !wall_is_behind):
		is_grounded = true
	else:
		is_grounded = false	
	
	if is_grounded:
		remaining_air_actions = data.max_air_actions
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


func set_screen_size(toggle_screen_size : bool):
	if toggle_screen_size:
		if using_stefan_screen_size:
			using_stefan_screen_size = false
		else:
			using_stefan_screen_size = true
	if verbose:
		print("using_stefan_screen_size set to ",using_stefan_screen_size)
	if using_stefan_screen_size:
		DisplayServer.window_set_size(Vector2i(stefan_screen_size))
	else:
		DisplayServer.window_set_size(Vector2i(daniel_screen_size))


func show_command_list():
	command_list_button_reset = false
	print("")
	print("AWSD/arrows  Move")
	print("      space  Jump")
	print("      enter  Dash")
#	print("      shift  Grab Wall")
	print("      shift  Move Slower")
	print("")
	print("          0  Show Command List")
	print("          9  Revive/Die")
	print("          -  Toggle Player Verbosity")
	print("        esc  Toggle Screen Size")
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

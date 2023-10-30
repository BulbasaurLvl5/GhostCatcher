class_name Player
extends CharacterBody2D

#level-dependent parameters
@export var facing_direction : int = 1

#development settings
@export var verbose : bool = false
@export var using_stefan_screen_size : bool = true
@export var stefan_screen_size : Vector2i = Vector2i(1152,648)
@export var daniel_screen_size : Vector2i = Vector2i(1920,1080)

#player data
#@export var player_data_sets : Array[PlayerDataResource]
@export var data : PlayerDataResource

#player status
@onready var x_input : int = 0
@onready var y_input : int = 0
@onready var input_direction : Vector2 = Vector2.ZERO
@onready var is_grounded : bool
@onready var can_touch_wall : bool
@onready var is_facing_wall : bool
@onready var remaining_air_actions : int = data.max_air_actions
@onready var last_touched_wall : bool = false
@onready var jump_button_reset : bool = false
@onready var dash_button_reset : bool = false
@onready var screen_size_button_reset : bool = false
@onready var current_player_data_preset : int = 0

func _ready():
	set_screen_size(false)

func _process(_delta):
	#input checks
	x_input = int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left"))
	y_input = int(Input.is_action_pressed("Down")) - int(Input.is_action_pressed("Up"))
#	if verbose:
#		print(input_direction," turned into ",x_input,y_input)
#	if verbose && (Input.is_action_pressed("Left") || Input.is_action_pressed("Right")) && x_input == 0:
#		print("X INPUT IS NOT REGISTERING!!!")
	if !jump_button_reset && !Input.is_action_pressed("Jump"):
		jump_button_reset = true
	if !dash_button_reset && !Input.is_action_pressed("Dash"):
		dash_button_reset = true
#	if !screen_size_button_reset && !Input.is_action_pressed("ScreenSize"):
#		screen_size_button_reset = true
	if Input.is_action_pressed("ScreenSize"):
		set_screen_size(true)
	if Input.is_action_pressed("CommandList"):
		show_command_list()
	if Input.is_action_pressed("PrevPlayerDataPreset"):
		prev_player_data_preset()
	if Input.is_action_pressed("NextPlayerDataPreset"):
		next_player_data_preset()
	
	
	#environmental checks
	$PlayerSprite2D/GroundCheckFront.force_raycast_update()	
	$PlayerSprite2D/GroundCheckBack.force_raycast_update()
	$PlayerSprite2D/WallCheckShoulder.force_raycast_update()
	$PlayerSprite2D/WallCheckToe.force_raycast_update()
	
	is_grounded = max(int($PlayerSprite2D/GroundCheckFront.is_colliding()), int($PlayerSprite2D/GroundCheckBack.is_colliding()))
	can_touch_wall = int($PlayerSprite2D/WallCheckShoulder.is_colliding())
	is_facing_wall = max(int(can_touch_wall), int($PlayerSprite2D/WallCheckToe.is_colliding()))
		
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
	print("AWSD/arrows  Move")
	print("      space  Jump")
	print("      enter  Dash")
	print("      shift  Grab Wall")
	print("    control  Move SLower")
	print("")
	print("          0  Show Command List")
	print("          9  Revive/Die")
	print("          -  Toggle Player Verbosity")
	print("        esc  Toggle Screen Size")
	print("    page up  Prev PlayerData Preset")
	print("  page down  Next PlayerData Preset")
	
func prev_player_data_preset():
#	current_player_data_preset -= 1
#	if current_player_data_preset < 0:
#		current_player_data_preset = 0
	pass
		

func next_player_data_preset():
#	current_player_data_preset += 1
#	if player_data_sets[current_player_data_preset] == null:
#		current_player_data_preset -= 1
	pass

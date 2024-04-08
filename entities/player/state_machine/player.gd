class_name Player
extends CharacterBody2D

#level-dependent parameters
@export var facing_direction : int = 1
@export var cast : ShapeCast2D
@export var grab_cast : ShapeCast2D
@export var canvas_mod_node : PackedScene

#development settings
@export var verbose : bool = false
@export var data : PlayerDataResource 

var level_boundary : Array[float]
var canvas_mod_dispatched : bool = false

var x_input : int = 0
var y_input : int = 0
var jump_input : bool = false
var jump_button_reset : bool = true
var dash_input : bool = false
var dash_button_reset : bool = true
var stomp_input : bool = false
var stomp_input_reset : bool = true
var last_dash_time : float = 0
var height_fallen_from : float = 0
var heavy_landing_factor : float = 0
var was_grounded : bool = false
var could_grab_wall : bool = false
var is_grabbing_wall : bool = false

@onready var remaining_air_actions : int = data.max_air_actions


func _enter_tree():
	print("ENTERING TREE")
	check_canvas_mod()


func find_starting_pos() -> Vector2:
	var pos : Vector2 = Vector2.ZERO
	var level_data : LevelData = get_tree().root.find_child("LvlData", true, false)
	if level_data:
		pos = level_data.starting_pos
		if level_data.flip_player_direction:
			facing_direction = -1
			%PlayerAnimatedSprite2D.scale.x = -1
			%RayCasts.scale.x = -1
	else:
		print("LevelData node not found by player.gd")
	return pos
		
		
func _ready():
	print("READY")

	global_position = find_starting_pos()
	print("starting position found is ",find_starting_pos())

	if !cast && %ShapeCast2D:
		cast = %ShapeCast2D
	if !canvas_mod_dispatched:
		check_canvas_mod()


func set_level_boundary(top : float, left : float, right : float, bottom : float):
	level_boundary = [top + 110, left + 110, right - 110, bottom - 110]


func _process(_delta):
	if !canvas_mod_dispatched:
		check_canvas_mod()
#	if !starting_position_set:
#		check_start_pos()
	check_input()
	check_environment()


func check_canvas_mod():
	var children = $"..".get_children()
	for c in children:
		if c is CanvasMod:
			return
	if children:
		var canvas_mod = canvas_mod_node.instantiate()
		$"..".add_child.call_deferred(canvas_mod)
		canvas_mod_dispatched = true


func pause_game():
	var path = "res://ui/menus/menu_pause.tscn"
	if ResourceLoader.exists(path) : 
		var pause_menu_packedscene = load(path)
		var pause_menu = pause_menu_packedscene.instantiate()
		var parent = get_tree().get_root().get_node("Main/UI")
		parent.add_child(pause_menu)
	else : 
		print("Error: in player.gd.pause_game() loading scene: ", path)
	pass


func check_input():
	if Input.is_action_pressed("Pause1") || Input.is_action_pressed(("Pause2")):
		pause_game()
	
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
	if Input.is_action_pressed("Stomp1") || Input.is_action_pressed("Stomp2"):
		stomp_input = true	
	else:
		stomp_input = false
		if !stomp_input_reset:
			stomp_input_reset = true

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
	if x_input != facing_direction:
		return false
	%GrabCheckTop.force_raycast_update()
	%GrabCheckInsideTop.force_raycast_update()
	%GrabCheckInsideBottom.force_raycast_update()
	%GrabCheckBottom.force_raycast_update()
	if %GrabCheckTop.is_colliding() && %GrabCheckBottom.is_colliding():
		return true
	if %GrabCheckTop.is_colliding() && %GrabCheckInsideBottom.is_colliding():
		var count = 0
		while !%GrabCheckBottom.is_colliding():
			position.y += -1
			%GrabCheckBottom.force_raycast_update()
			count += 1
			if count > 12:
				print("Player is being adjusted more than intended attempting to wall grab.")
				return false
#		print("Player adjusted UP to grab wall.  pixels: ",count)
		return true
	if %GrabCheckBottom.is_colliding() && %GrabCheckInsideTop.is_colliding():
		var count = 0
		while !%GrabCheckTop.is_colliding():
			position.y += 1
			%GrabCheckTop.force_raycast_update()
			count += 1
			if count > 12:
				print("Player is being adjusted more than intended attempting to wall grab.")
				return false
#		print("Player adjusted DOWN to grab wall.  pixels: ",count)
		return true
	return false

func can_jump() -> bool:
	if !jump_input || !jump_button_reset:
		return false
	if !$CoyoteTime.is_stopped() || remaining_air_actions > 0 || is_grounded():
		return true
	return false

func can_dash() -> bool:
	if !dash_input || !dash_button_reset:
		return false
	if !is_grounded() && (!$CoyoteTime.is_stopped() || remaining_air_actions > 0):
		return true
	if is_grounded() && last_dash_time + data.ground_dash_cooldown < Time.get_unix_time_from_system():
		return true
	return false
		
func can_stomp() -> bool:
	if stomp_input && stomp_input_reset && !is_on_floor():
		return true
	return false

func is_bumping_head() -> bool:
	%HeadBumpCheckFront.force_raycast_update()
	%HeadBumpCheckBack.force_raycast_update()
	if %HeadBumpCheckFront.is_colliding() || %HeadBumpCheckBack.is_colliding():
		return true
	return false

func air_action():
	if $CoyoteTime.is_stopped():
		remaining_air_actions -= 1

func stop_motion():
	velocity = Vector2.ZERO
	move_and_slide()

func move():
	if level_boundary:
		if position.y <= level_boundary[0] && velocity.y < 0:
			velocity.y = 0
		if position.x <= level_boundary[1] && velocity.x < 0:
			velocity.x = 0
		if position.x >= level_boundary[2] && velocity.x > 0:
			velocity.x = 0
		if position.y >= level_boundary[3] && velocity.y > 0:
			velocity.y = 0
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

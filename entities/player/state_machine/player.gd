class_name Player
extends CharacterBody2D

#level-dependent parameters
@export var facing_direction : int = 1
#@export var cast : ShapeCast2D
#@export var grab_cast : ShapeCast2D
@export var canvas_mod_node : PackedScene

#development settings
@export var verbose : bool = false
@export var data : PlayerDataResource 

var level_boundary : Rect2:
	set(value):
		level_boundary = value
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

enum SuperStates {IN_AIR, GROUNDED, ON_WALL}
var super_state : int = SuperStates.IN_AIR:
	set(value):
		if super_state == value:
			return
		super_state = value
		if verbose:
			print("PLAYER super_state = ", super_state)
		if super_state == SuperStates.IN_AIR:
			%CrowPointLight2D1.energy = 5.0
			%CrowPointLight2D2.energy = 5.0
		else:
			%CrowPointLight2D1.energy = 1.0
			%CrowPointLight2D2.energy = 1.0
			remaining_air_actions = data.max_air_actions
			
@onready var remaining_air_actions : int = data.max_air_actions:
	set(value):
		if remaining_air_actions == value:
			return
		remaining_air_actions = clamp(value, 0, data.max_air_actions)
		if remaining_air_actions >= 1:
			%AirActionCrow1.visible = true
		else:
			%AirActionCrow1.visible = false
		if remaining_air_actions == 2:
			%AirActionCrow2.visible = true
		else:
			%AirActionCrow2.visible = false


func _enter_tree():
	check_canvas_mod()

		
func _ready():
	#if !cast && %ShapeCast2D:
		#cast = %ShapeCast2D
	if !canvas_mod_dispatched:
		check_canvas_mod()


func _process(_delta):
	if !canvas_mod_dispatched:
		check_canvas_mod()
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
	if super_state == SuperStates.IN_AIR:
		if is_on_floor():
			super_state = SuperStates.GROUNDED
	elif super_state == SuperStates.GROUNDED:
		if !is_on_floor():
			super_state = SuperStates.IN_AIR

	was_grounded = is_on_floor()
	could_grab_wall = can_grab_wall()
	
	
#func is_grounded() -> bool:
	#if get_collisions(Vector2.DOWN * 2.0):
		#remaining_air_actions = data.max_air_actions
		#return true
	#else:
		#return false


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
	if super_state == SuperStates.GROUNDED || super_state == SuperStates.ON_WALL:
		return true
	if !$CoyoteTime.is_stopped() || remaining_air_actions > 0:
		return true
	return false


func can_dash() -> bool:
	if !dash_input || !dash_button_reset:
		return false
	if super_state == SuperStates.IN_AIR:
		if (!$CoyoteTime.is_stopped() || remaining_air_actions > 0):
			return true
	elif super_state == SuperStates.GROUNDED:
		if last_dash_time + data.ground_dash_cooldown < Time.get_unix_time_from_system():
			return true
	elif super_state == SuperStates.ON_WALL:
		return true
	return false


func can_stomp() -> bool:
	if stomp_input && stomp_input_reset && super_state != SuperStates.GROUNDED:
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
		if position.y <= level_boundary.position.y && velocity.y < 0:
			velocity.y = 0
		if position.x <= level_boundary.position.x && velocity.x < 0:
			velocity.x = 0
		if position.x >= level_boundary.end.x && velocity.x > 0:
			velocity.x = 0
		if position.y >= level_boundary.end.y && velocity.y > 0:
			velocity.y = 0
	move_and_slide()
	

#func get_collisions(offset : Vector2 = Vector2.ZERO, ignore_areas : bool = true, shape_cast : ShapeCast2D = cast) -> Array:
	#var array : Array = []
	#shape_cast.position += offset
	#shape_cast.force_shapecast_update()
	#if shape_cast.is_colliding():
		#var total = shape_cast.get_collision_count()
		#var count = 0
		#while count < total:
			#array.append(shape_cast.get_collider(count))
			#count += 1
	#if shape_cast == cast:
		#cast.position = Vector2.ZERO
	#else:
		#shape_cast.position -= offset
	#if ignore_areas:
		#for n in array:
			#if n is Area2D:
				#array.erase(n)
	#return array


#func get_all_children(node) -> Array:
	#if !node:
		#return []
	#var all_children : Array = []
	#var children = node.get_children()
	#for c in children:
		#if c.get_child_count() > 0:
			#all_children.append(c)
			#all_children.append_array(get_all_children(c))
		#else:
			#all_children.append(c)
	#return all_children

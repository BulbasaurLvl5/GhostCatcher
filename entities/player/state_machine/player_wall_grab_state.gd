class_name PlayerWallGrabState
extends PlayerState


@export_range(-10.0, 10.0, 0.001, "or_less", "or_greater", "suffix:pixels") var visual_offset_x : float = 0

var wall_direction : int
var on_moving_tile_map : bool
var stored_wall_pos : Vector2


func Enter(_from : PlayerState = null):
	player.super_state = player.SuperStates.ON_WALL
	player.velocity = Vector2(100.0 * player.facing_direction, 0.0)
	#player.move()
	on_moving_tile_map = false
	if player.moving_platform:
		if player.moving_platform is MovingTileMap:
			on_moving_tile_map = true
			stored_wall_pos = player.moving_platform.position

	anim.offset.x += visual_offset_x
	anim.play("wall_grab")
	$"../../SFX/WallGrab".play()
	wall_direction = player.facing_direction
	#player.stop_motion()
	if data.wall_grab_resets_air_actions:
		player.remaining_air_actions = data.max_air_actions


func Do_Checks():
	if player.can_jump():
		Transitioned.emit(self,"WallJump")
	elif player.can_dash():
		Flip_Player(true)
		Transitioned.emit(self,"Dash")
	#elif player.can_stomp():
		#Transitioned.emit(self,"Stomp")
	elif player.x_input != wall_direction || (player.super_state != player.SuperStates.ON_WALL && !player.can_grab_wall()):
		%CoyoteTime.set_wait_time(data.coyote_time_wall)
		%CoyoteTime.start()
		Transitioned.emit(self,"InAir")	


#func Update(_delta):
	#if anim.animation != "wall_grab":
		#anim.play("wall_grab")
		#print("RESETTING WALL GRAB ANIMATION") 


func Physics_Update(delta):
	if on_moving_tile_map:
		player.velocity = (player.moving_platform.global_position - stored_wall_pos) / delta
		stored_wall_pos = player.moving_platform.global_position
	if abs(player.velocity.x) < 5.0:
		player.velocity.x = 5.0 * player.facing_direction
	player.move()


func Exit():
	anim.offset.x -= visual_offset_x
	player.height_fallen_from = player.position.y
	if player.super_state == player.SuperStates.ON_WALL:
		player.super_state = player.SuperStates.IN_AIR


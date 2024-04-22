class_name PlayerWallGrabState
extends PlayerState


@export_range(-10.0, 10.0, 0.001, "or_less", "or_greater", "suffix:pixels") var visual_offset_x : float = 0

@onready var wall_direction : int
@onready var wall : Node


func Enter(_from : PlayerState = null):
	player.super_state = player.SuperStates.ON_WALL
	anim.offset.x += visual_offset_x
	anim.play("wall_grab")
	$"../../SFX/WallGrab".play()
	wall_direction = player.facing_direction
	player.stop_motion()
	if data.wall_grab_resets_air_actions:
		player.remaining_air_actions = data.max_air_actions


func Do_Checks():
	if player.can_jump():
		Transitioned.emit(self,"WallJump")
	elif player.can_dash():
		Flip_Player(true)
		Transitioned.emit(self,"Dash")
	elif player.can_stomp():
		Transitioned.emit(self,"Stomp")
	elif player.x_input != wall_direction || (player.super_state != player.SuperStates.ON_WALL && !player.can_grab_wall()):
		%CoyoteTime.set_wait_time(data.coyote_time_wall)
		%CoyoteTime.start()
		Transitioned.emit(self,"InAir")	


func Physics_Update(_delta):
#	player.velocity.y = -1
#	print("player velocity = = = = = ",player.velocity)
	player.move()


func Exit():
	anim.offset.x -= visual_offset_x
	player.height_fallen_from = player.position.y
	if player.super_state == player.SuperStates.ON_WALL:
		player.super_state = player.SuperStates.IN_AIR


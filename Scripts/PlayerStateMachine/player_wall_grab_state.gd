class_name PlayerWallGrabState
extends PlayerState


@export var visual_offset : float = 0

@onready var wall_direction : int
@onready var wall : Node


func Enter():
	player.is_grabbing_wall = true
	anim.offset.x += visual_offset
	anim.play("wall_grab")
	$"../../SFX/WallGrab".play()
	wall_direction = player.facing_direction
	player.stop_motion()
	if data.wall_grab_resets_air_actions:
		player.remaining_air_actions = data.max_air_actions


func Do_Checks():
	if player.can_jump():
		anim.offset.x -= visual_offset
		player.is_grabbing_wall = false
		Transitioned.emit(self,"WallJump")
	elif player.can_dash():
		anim.offset.x -= visual_offset
		player.is_grabbing_wall = false
		player.facing_direction *= -1
		anim.scale.x *= -1
		Transitioned.emit(self,"Dash")
	elif player.x_input != wall_direction || (!player.is_on_wall() && !player.can_grab_wall()):
		%CoyoteTime.start()
		anim.offset.x -= visual_offset
		player.is_grabbing_wall = false
		Transitioned.emit(self,"InAir")	


func Physics_Update(_delta):
#	player.velocity.y = -1
#	print("player velocity = = = = = ",player.velocity)
	player.move_and_slide()


func Flip_Player():
	#cannot flip while grabbing wall
	pass

class_name PlayerWallGrabState
extends PlayerState


@export var visual_offset : float = 0

@onready var wall_direction : int
@onready var wall : Node


func Enter():
	player.is_grabbing_wall = true
#	if verbose:
#		print("Is grabbing wall!!!!!!!!!!!")
	anim.offset.x += visual_offset
	anim.play("wall_grab")
	wall_direction = player.facing_direction
	player.stop_motion()
	if data.wall_grab_resets_air_actions:
		player.remaining_air_actions = data.max_air_actions


func Do_Checks():
	if player.jump_input && player.jump_button_reset:
		anim.offset.x -= visual_offset
		player.is_grabbing_wall = false
#		if verbose:
#			print("IS NOT GRABBING WALL")
		Transitioned.emit(self,"WallJump")
	elif player.dash_input && player.dash_button_reset:
		anim.offset.x -= visual_offset
		player.is_grabbing_wall = false
#		if verbose:
#			print("IS NOT GRABBING WALL")
		player.facing_direction *= -1
		anim.scale.x *= -1
		Transitioned.emit(self,"Dash")
	elif player.x_input != wall_direction || !player.can_touch_wall:
		if player.x_input == wall_direction && player.moving_platform != null:
			check_moving_platform_grab()
#		if player.x_input == player.facing_direction * -1:
#			player.facing_direction *= -1
#			$"../../PlayerAnimatedSprite2D".scale.x *= -1
		$"../../CoyoteTime".start()
		player.last_touched_wall = true
		anim.offset.x -= visual_offset
		player.is_grabbing_wall = false
#		if verbose:
#			print("IS NOT GRABBING WALL because x_input = ",player.x_input," & wall_direction = ",wall_direction)
#		if player.facing_direction != player.x_input && abs(player.x_input) == 1:
#			player.facing_direction *= -1
#			anim.scale.x *= -1
		Transitioned.emit(self,"InAir")	


func check_moving_platform_grab():
	pass

		
func Flip_Player():
	#cannot flip while grabbing wall
	pass

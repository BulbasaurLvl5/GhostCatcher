class_name PlayerWallGrabState
extends PlayerState


@export var visual_offset : float = 0

@onready var wall_direction : int
@onready var wall : Node


func Enter():
	player.is_grabbing_wall = true
	$"../../PlayerAnimatedSprite2D".offset.x += visual_offset
	anim.play("wall_grab")
	wall_direction = player.facing_direction
	player.stop_motion()
	if data.wall_grab_resets_air_actions:
		player.remaining_air_actions = data.max_air_actions


func Do_Checks():
	if player.jump_input && player.jump_button_reset:
		$"../../PlayerAnimatedSprite2D".offset.x -= visual_offset
		player.is_grabbing_wall = false
		Transitioned.emit(self,"WallJump")
	elif player.x_input != wall_direction || !player.is_facing_wall:
		if player.x_input == player.facing_direction * -1:
			player.facing_direction *= -1
			$"../../PlayerAnimatedSprite2D".scale.x *= -1
		$"../../CoyoteTime".start()
		player.last_touched_wall = true
		$"../../PlayerAnimatedSprite2D".offset.x -= visual_offset
		player.is_grabbing_wall = false
		Transitioned.emit(self,"InAir")	
		

func Flip_Player():
	#cannot flip while grabbing wall
	pass

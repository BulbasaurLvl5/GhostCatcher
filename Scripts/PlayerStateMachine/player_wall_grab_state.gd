class_name PlayerWallGrabState
extends PlayerState


@onready var wall_direction : int


func Enter():
	anim.play("wall_grab")
	
	wall_direction = player.facing_direction
	player.velocity = Vector2.ZERO
	if data.wall_grab_resets_air_actions:
		player.remaining_air_actions = data.max_air_actions


func Do_Checks():
	if Input.is_action_pressed("Jump") && player.jump_button_reset:
		Transitioned.emit(self,"WallJump")
	elif player.x_input != wall_direction || !player.is_facing_wall:
		if player.x_input == player.facing_direction * -1:
			player.facing_direction *= -1
			$"../../PlayerSprite2D".scale.x *= -1
		$"../../CoyoteTime".start()
		player.last_touched_wall = true
		Transitioned.emit(self,"InAir")	


func Flip_Player():
	#cannot flip while grabbing wall
	pass

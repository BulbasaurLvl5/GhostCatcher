class_name PlayerJumpState
extends PlayerState


var hold_time_remaining : float
@onready var jump_noise : int = 1


func Enter():
	anim.play("jump")
	if jump_noise == 1:
		$"../../SFX/Jump1".play()
		jump_noise = 2
	else:
		$"../../SFX/Jump2".play()
		jump_noise = 1
	player.jump_button_reset = false
	hold_time_remaining = data.jump_max_hold_time
	player.velocity.y = data.jump_force
#	if player.verbose && player.moving_platform != null:
#		print("Player is LEAVING moving platform ",player.moving_platform)
#	player.moving_platform = null
	
	
func _animation_finished():
	anim.play("hover")


func Do_Checks():
	if player.can_jump():
		player.air_action()
		Transitioned.emit(self,"Jump")
	elif player.can_dash():
		player.air_action()
		Transitioned.emit(self,"Dash") 

	if player.velocity.y >= 0 || player.get_collisions(Vector2.UP):
		%InAir.hang_time_active = true
		Transitioned.emit(self,"InAir")
	elif data.wall_grab_allowed_while_ascending && player.can_grab_wall():
		player.stop_motion()
		Transitioned.emit(self,"WallGrab")
		
		
func Physics_Update(delta):
	if player.jump_input && hold_time_remaining > 0:
		player.velocity.y = data.jump_force 
		hold_time_remaining -= delta
	else:
		hold_time_remaining = 0
		player.velocity.y += data.gravity * delta
		if player.velocity.y > data.max_fall_speed:
			player.velocity.y = data.max_fall_speed
			
	player.velocity.x = data.in_air_horizontal_speed * player.x_input 
	player.move_and_slide()

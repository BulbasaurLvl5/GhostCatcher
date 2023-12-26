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
	player.momentum.y = data.jump_force
#	if player.verbose && player.moving_platform != null:
#		print("Player is LEAVING moving platform ",player.moving_platform)
	player.moving_platform = null
	
	
func _animation_finished():
	anim.play("hover")


func Do_Checks():
#	if hold_time_remaining <= 0:
	if player.jump_input && player.can_jump():
		player.air_action()
		Transitioned.emit(self,"Jump")
	elif player.dash_input && player.can_dash():
		player.air_action()
		Transitioned.emit(self,"Dash") 

	var collisions = player.get_collisions(Vector2.UP)
	if collisions || player.momentum.y >= 0:
		%InAir.hang_time_active = true
		Transitioned.emit(self,"InAir")
	elif data.wall_grab_allowed_while_ascending && player.can_touch_wall && player.x_input == player.facing_direction:
		player.stop_motion()
		Transitioned.emit(self,"WallGrab")
		
		
func Physics_Update(delta):
	var motion = Vector2.ZERO
	if player.jump_input && hold_time_remaining > 0:
		motion.y = data.jump_force * delta
		hold_time_remaining -= delta
	else:
		hold_time_remaining = 0
		motion.y = move_toward(player.momentum.y, data.max_fall_speed, data.gravity * delta)
	motion.x = data.in_air_horizontal_speed * player.x_input * delta
	player.move_xy(motion)

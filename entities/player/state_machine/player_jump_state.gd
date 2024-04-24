class_name PlayerJumpState
extends PlayerState


@onready var jump_noise : int = 1


func Enter(_from : PlayerState = null):
	anim.play("jump")
	if jump_noise == 1:
		$"../../SFX/Jump1".play()
		jump_noise = 2
	else:
		$"../../SFX/Jump2".play()
		jump_noise = 1
	player.jump_button_reset = false
	player.velocity.y = data.jump_force
	
	
func _animation_finished():
	anim.play("hover")


func Do_Checks():
	Flip_Player()
	Check_Altitude()
	if player.can_jump():
		player.air_action()
		Initiate_Exit()
		Initiate_Enter(self)
		return
	elif player.can_dash():
		player.air_action()
		Transitioned.emit(self,"Dash")
	elif player.can_stomp():
		Transitioned.emit(self,"Stomp")
	elif player.velocity.y > 0 || player.is_on_ceiling():
		Transitioned.emit(self,"InAir")
	elif player.y_input >= 0:
		if player.can_grab_wall():
			player.stop_motion()
			Transitioned.emit(self,"WallGrab")
		
		
func Physics_Update(delta):
	if time_in_current_state < data.jump_max_hold_time:
		if player.jump_input:
			var progress = clampf(time_in_current_state / data.jump_max_hold_time, 0.0, 1.0)
			player.velocity.y = lerpf(-data.starting_jump_force, -data.ending_jump_force, progress)
		else:
			player.velocity.y += data.gravity * lerpf(data.early_gravity_multiplier, 2.0, time_in_current_state / data.jump_max_hold_time) * delta
	else:
		player.velocity.y += data.gravity * delta
	player.velocity.x = data.in_air_horizontal_speed * player.x_input 
	player.move()


func Exit():
	player.height_fallen_from = player.position.y

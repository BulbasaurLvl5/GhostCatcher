class_name PlayerJumpState
extends PlayerState


@onready var jump_noise : int = 1


func Enter(_from : PlayerState = null):
	player.moving_platform = null
	if abs(player.velocity.x) > data.in_air_horizontal_speed && sign(player.velocity.x) == player.x_input:
		player.extra_momentum = sign(player.velocity.x) * min(abs(player.velocity.x), data.max_run_speed)
	else:
		player.extra_momentum = 0.0
	
	anim.play("jump")
	if jump_noise == 1:
		$"../../SFX/Jump1".play()
		jump_noise = 2
	else:
		$"../../SFX/Jump2".play()
		jump_noise = 1
	player.jump_button_reset = false
	player.velocity.y = -1 * data.initial_jump_force
	
	
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
	#elif player.can_stomp():
		#Transitioned.emit(self,"Stomp")
	elif player.velocity.y > 0 || player.is_on_ceiling():
		Transitioned.emit(self,"InAir")
	elif player.y_input >= 0:
		if player.can_grab_wall():
			player.stop_motion()
			Transitioned.emit(self,"WallGrab")
		
		
func Physics_Update(delta):
	if player.jump_input && time_in_current_state <= data.jump_max_hold_time:
		player.velocity.y -= data.ongoing_jump_force * delta
		player.velocity.y += data.gravity * delta
	else:
		player.velocity.y += data.gravity * data.max_gravity_multiplier * delta
	if abs(player.extra_momentum) > data.in_air_horizontal_speed && sign(player.extra_momentum) == player.x_input:
		player.velocity.x = player.extra_momentum
	else:
		player.velocity.x = data.in_air_horizontal_speed * player.x_input 
	player.move()


func Exit():
	player.height_fallen_from = player.position.y

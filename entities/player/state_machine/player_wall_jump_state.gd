class_name PlayerWallJumpState
extends PlayerState


@onready var jump_velocity : float
@onready var jump_gravity : float
@onready var wall_jump_direction : int


func Enter(_from : PlayerState = null):
	player.moving_platform = null
	if player.y_input < 0:
		Transitioned.emit(self,"Jump")
		return
	anim.play("jump")
	if %Jump.jump_noise == 1:
		$"../../SFX/Jump1".play()
		%Jump.jump_noise = 2
	else:
		$"../../SFX/Jump2".play()
		%Jump.jump_noise = 1
	Flip_Player(true)
	wall_jump_direction = player.facing_direction
	player.jump_button_reset = false
	player.velocity.y = -1 * data.initial_jump_force
	
	
func _animation_finished():
	anim.play("in-air")


func Do_Checks():
	Check_Altitude()
	if player.velocity.y > 0 && time_in_current_state > 0.1:
		Transitioned.emit(self,"InAir")
	elif player.can_jump():
		player.air_action()
		Transitioned.emit(self,"Jump")
	elif player.can_dash() && !player.jump_input:
		player.air_action()
		Transitioned.emit(self,"Dash")
	elif player.can_stomp() && !player.jump_input:
		Transitioned.emit(self,"Stomp")
	elif player.velocity.y > 0 || player.is_on_ceiling():
		Transitioned.emit(self,"InAir")
	elif player.y_input >= 0 && time_in_current_state > 0.2:
		if player.can_grab_wall():
			Transitioned.emit(self,"WallGrab")
	if time_in_current_state > data.wall_jump_force_duration || !player.jump_input:
		Flip_Player()
		
	
func Physics_Update(delta):
	if player.jump_input && time_in_current_state <= data.jump_max_hold_time:
		player.velocity.y -= data.ongoing_jump_force * delta
		player.velocity.y += data.gravity * delta
	else:
		player.velocity.y += data.gravity * data.max_gravity_multiplier * delta
	player.velocity.x = data.in_air_horizontal_speed * player.facing_direction
	player.move()
	
	
func Exit():
	player.height_fallen_from = player.position.y

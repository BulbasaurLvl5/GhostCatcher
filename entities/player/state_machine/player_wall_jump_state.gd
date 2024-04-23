class_name PlayerWallJumpState
extends PlayerState


@onready var jump_velocity : float
@onready var jump_gravity : float
@onready var wall_jump_direction : int


func Enter(_from : PlayerState = null):
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
	
	
func _animation_finished():
	anim.play("in-air")


func Do_Checks():
	Check_Altitude()
	if player.velocity.y > 0:
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
	if time_in_current_state < data.jump_max_hold_time:
		if player.jump_input:
			var progress = clampf(time_in_current_state / data.jump_max_hold_time, 0.0, 1.0)
			player.velocity.y = lerpf(data.jump_force, data.jump_force * 0.7, progress)
		else:
			player.velocity.y += data.gravity * lerpf(10.0, 2.0, time_in_current_state / data.jump_max_hold_time) * delta
	else:
		player.velocity.y += data.gravity * delta
	player.velocity.x = player.facing_direction * data.in_air_horizontal_speed
	player.move()
	
	
func Exit():
	player.height_fallen_from = player.position.y

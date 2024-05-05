class_name PlayerRunState
extends PlayerState


var sound : AudioStreamPlayer2D
var current_speed : float:
	set(value):
		if current_speed == value:
			return
		current_speed = value
		var relative_speed = abs(current_speed / data.max_run_speed)
		anim.speed_scale = relative_speed
		sound.pitch_scale = clamp(relative_speed * 1.5, 1.0, 1.5)


func Enter(from : PlayerState = null):
	anim.play("run")
	sound = $"../../SFX/Run"
	sound.play()
	if from is PlayerLandState || from is PlayerIdleState:
		current_speed = data.min_run_speed * player.x_input
	else:
		current_speed = data.in_air_horizontal_speed * player.x_input
	

func Do_Checks():
	Flip_Player()
	if player.super_state != player.SuperStates.GROUNDED:
		%CoyoteTime.set_wait_time(data.coyote_time_ground)
		%CoyoteTime.start()
		sound.stop()
		Transitioned.emit(self,"InAir")
	elif player.can_jump():
		sound.stop()
		Transitioned.emit(self,"Jump")
	elif player.can_dash():
		sound.stop()
		Transitioned.emit(self,"Dash")
	elif player.x_input == 0:
		sound.stop()
		Transitioned.emit(self,"Idle")
		
		
func Physics_Update(delta):
	if sign(player.velocity.x) != player.x_input:
		player.velocity.x = data.min_run_speed * player.x_input
		
	if abs(player.velocity.x) < data.max_run_speed:
		player.velocity.x += player.x_input * data.run_acceleration * delta
		if abs(player.velocity.x) > data.max_run_speed:
			player.velocity.x = data.max_run_speed * sign(player.velocity.x)
		current_speed = player.velocity.x

	Grounded_Gravity(delta)
	player.move()


func Exit():
	player.height_fallen_from = player.position.y

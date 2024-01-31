class_name PlayerInAirState
extends PlayerState


var hang_time_active : bool = false


func Enter(from : PlayerState = null):
	if from:
		var states = ["Run", "Jump", "Dash", "WallGrab", "WallJump"]
		if states.has(from.name):
			hang(true)
		else:
			hang(false)
	else:
		hang(false)
	Flip_Player()
	Check_Altitude()

func hang(active : bool):
	hang_time_active = active
	if active:
		anim.play("hover")
	else:
		anim.play("fall")


func Do_Checks():
	Flip_Player()
	Check_Altitude()

	if player.is_on_floor():
		hang_time_active = false
		if player.position.y - player.height_fallen_from > data.distance_before_medium_landing:
			Transitioned.emit(self,"Land")
		else: 
			$"../../SFX/Land1".play()
			if player.x_input == 0:
				Transitioned.emit(self,"Idle")
			else: 
				Transitioned.emit(self,"Run")
	elif player.can_jump():
		player.air_action()
		Transitioned.emit(self,"Jump")
	elif player.can_dash():
		player.air_action()
		Transitioned.emit(self,"Dash")
	elif player.can_stomp():
		Transitioned.emit(self,"Stomp")
	elif player.can_grab_wall():
		player.stop_motion()
		Transitioned.emit(self,"WallGrab")
	
		
func Update(_delta):
	if hang_time_active && time_in_current_state > data.hang_time_duration:
		hang_time_active = false
		anim.play("fall", true)


func Physics_Update(delta):
	if hang_time_active:
		player.velocity.y = 0
	else:
		if player.velocity.y < 200:
			player.velocity.y += 0.5 * data.gravity * delta
		elif player.velocity.y < 400:
			player.velocity.y += 0.75 * data.gravity * delta
		else:
			player.velocity.y += data.gravity * delta
		if player.velocity.y > data.max_fall_speed:
			player.velocity.y = data.max_fall_speed
	player.velocity.x = player.x_input * data.in_air_horizontal_speed
	player.move()

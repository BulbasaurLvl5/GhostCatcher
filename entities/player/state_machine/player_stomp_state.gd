class_name PlayerStompState
extends PlayerState


func Enter(_from : PlayerState = null):
	anim.play("fall")
	Check_Altitude()
	if player.velocity.y >= data.max_fall_speed:
		player.velocity.y = 1.2 * data.max_fall_speed
	else:
		player.velocity.y += 0.2 * data.max_fall_speed
	if player.velocity.y < 0.8 * data.max_fall_speed:
		player.velocity.y = 0.8 * data.max_fall_speed

		
func Do_Checks():
	Flip_Player()
	Check_Altitude()
	if player.super_state == player.SuperStates.GROUNDED:
		Transitioned.emit(self,"Land")
	elif player.can_jump():
		player.air_action()
		Transitioned.emit(self,"Jump")
	elif player.can_dash():
		player.air_action()
		Transitioned.emit(self,"Dash")
	elif !player.stomp_input:
		if player.can_grab_wall():
			player.stop_motion()
			Transitioned.emit(self,"WallGrab")
		else:
			Transitioned.emit(self,"InAir")


func Physics_Update(delta):
	player.velocity.y += data.gravity * delta
	if player.velocity.y > 1.5 * data.max_fall_speed:
		player.velocity.y = 1.5 * data.max_fall_speed
	player.velocity.x = player.x_input * data.in_air_horizontal_speed
	player.move()

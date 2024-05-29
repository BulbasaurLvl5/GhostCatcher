class_name PlayerIdleState
extends PlayerState


var timer : float = 42.0


func Enter(_from : PlayerState = null):
	anim.play("idle")
	player.stop_motion()
	player.landed.emit()
	
	
func Do_Checks():
	Flip_Player()
	if player.super_state == player.SuperStates.IN_AIR:
		%CoyoteTime.set_wait_time(data.coyote_time_ground)
		%CoyoteTime.start()
		Transitioned.emit(self,"InAir")
	elif player.can_jump():
		Transitioned.emit(self,"Jump")
	elif player.can_dash():
		Transitioned.emit(self,"Dash")
	elif abs(player.x_input) == 1:
		Transitioned.emit(self,"Run")
	elif player.can_grab_wall():
		player.stop_motion()
		Transitioned.emit(self,"WallGrab")


func Update(delta):
	#THIS IS HERE FOR PLAYING AN ALTERNATE IDLE ANIMATION
	if timer <= 0:
		anim.play("idle")
		timer = 42.0
	else:
		timer -= delta
		

func Physics_Update(delta):
	Grounded_Gravity(delta)
	player.move()


func Exit():
	player.height_fallen_from = player.position.y

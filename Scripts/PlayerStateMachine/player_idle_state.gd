class_name PlayerIdleState
extends PlayerState


var timer : float = 42.0


func Enter(_from : PlayerState = null):
	anim.play("idle")
	player.stop_motion()
	
	
func Do_Checks():
	Flip_Player()
	if !player.is_on_floor():
		%CoyoteTime.set_wait_time(data.coyote_time_ground)
		%CoyoteTime.start()
		Transitioned.emit(self,"InAir")
	elif player.can_jump():
		Transitioned.emit(self,"Jump")
	elif player.can_dash():
		Transitioned.emit(self,"Dash")
	elif abs(player.x_input) == 1:
		Transitioned.emit(self,"Run")


func Update(delta):
	#THIS IS HERE FOR PLAYING AN ALTERNATE IDLE ANIMATION
	if timer <= 0:
		anim.play("idle")
		timer = 42.0
	else:
		timer -= delta
		

func Physics_Update(_delta):
#	player.velocity.y = 100
	player.move_and_slide()


func Exit():
	player.height_fallen_from = player.position.y

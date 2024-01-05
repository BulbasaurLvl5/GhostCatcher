class_name PlayerIdleState
extends PlayerState


var timer : float = 42.0


func Enter():
	anim.play("idle")
	player.stop_motion()
	
	
func Do_Checks():
#	if player.is_on_floor():
#		print("PLAYER IS ON FLOOR")
	
	if !player.is_on_floor():
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
	player.velocity.y = 100
#	print("player vwelocity = = = = = ",player.velocity)
	player.move_and_slide()
	

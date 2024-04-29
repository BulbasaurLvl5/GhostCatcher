class_name PlayerRunState
extends PlayerState


var sound : AudioStreamPlayer2D


func Enter(_from : PlayerState = null):
	anim.play("run")
	sound = $"../../SFX/Run"
	sound.play()
	
	
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
	player.velocity.y += data.gravity * delta
	player.velocity.x = data.run_speed * player.x_input
	player.move()


func Exit():
	player.height_fallen_from = player.position.y

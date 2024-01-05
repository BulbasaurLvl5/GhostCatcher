class_name PlayerRunState
extends PlayerState


var sound : AudioStreamPlayer2D


func Enter():
	anim.play("run")
	sound = $"../../SFX/Run"
	sound.play()
	
	
func Do_Checks():
	if !player.is_on_floor():
		$"../../CoyoteTime".start()
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
		
		
func Physics_Update(_delta):
	player.velocity = Vector2(data.run_speed * player.x_input, 0)
	player.move_and_slide()

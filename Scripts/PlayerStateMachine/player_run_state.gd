class_name PlayerRunState
extends PlayerState


func Enter():
	anim.play("run")
	
	
func Do_Checks():
	if !player.is_grounded:
		$"../../CoyoteTime".start()
		Transitioned.emit(self,"InAir")
	elif player.jump_input && player.jump_button_reset:
		Transitioned.emit(self,"Jump")
	elif player.dash_input && player.dash_button_reset&& player.last_dash_time + data.ground_dash_cooldown < Time.get_unix_time_from_system():
		Transitioned.emit(self,"Dash")
	elif player.x_input == 0:
		Transitioned.emit(self,"Idle")
		
		
func Physics_Update(delta):
	var motion = Vector2(data.run_speed * delta * player.x_input, 0)
	player.move_xy(motion)

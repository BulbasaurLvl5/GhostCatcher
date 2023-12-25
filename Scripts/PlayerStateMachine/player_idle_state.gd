class_name PlayerIdleState
extends PlayerState


func Enter():
	anim.play("idle")
	player.stop_motion()
	
	
func Do_Checks():
	if !player.is_grounded:
		$"../../CoyoteTime".start()
		Transitioned.emit(self,"InAir")
	elif player.jump_input && player.jump_button_reset:
		Transitioned.emit(self,"Jump")
	elif player.dash_input && player.dash_button_reset && player.last_dash_time + data.ground_dash_cooldown < Time.get_unix_time_from_system():
		Transitioned.emit(self,"Dash")
	elif abs(player.x_input) == 1:
		Transitioned.emit(self,"Run")

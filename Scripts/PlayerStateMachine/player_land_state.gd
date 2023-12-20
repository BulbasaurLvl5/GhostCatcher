class_name PlayerLandState
extends PlayerState

var heavy_landing : bool = false


func Enter():
	if heavy_landing:
		anim.play("land")
	else:
		anim.play("land")


func Do_Checks():
	if !heavy_landing:
		if player.jump_input && player.can_jump:
			Transitioned.emit(self,"Jump")
		elif player.dash_input && player.dash_button_reset&& player.last_dash_time + data.ground_dash_cooldown < Time.get_unix_time_from_system():
			Transitioned.emit(self,"Dash")
		elif abs(player.x_input) == 1:
			Transitioned.emit(self,"Run")
			
	if time_in_current_state > 1.0:
		if player.jump_input && player.can_jump:
			Transitioned.emit(self,"Jump")
		elif abs(player.x_input) == 1:
			Transitioned.emit(self,"Run")
		else:
			Transitioned.emit(self,"Idle")
	

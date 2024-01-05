class_name PlayerLandState
extends PlayerState

var heavy_landing : bool = false

func Enter():
	if heavy_landing:
		%Camera2D.apply_shake()
		anim.play("land")
		$"../../SFX/Land3".play()
	else:
		anim.play("land")
		$"../../SFX/Land2".play()

func Do_Checks():
	if !heavy_landing || time_in_current_state > 1.0:
		if player.can_jump():
			Transitioned.emit(self,"Jump")
		elif player.can_dash():
			Transitioned.emit(self,"Dash")
		elif abs(player.x_input) == 1:
			Transitioned.emit(self,"Run")
		elif time_in_current_state > 1.0:
			Transitioned.emit(self,"Idle")
	

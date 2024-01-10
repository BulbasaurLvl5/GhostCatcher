class_name PlayerLandState
extends PlayerState


var distance_fallen : float


func Enter(from : PlayerState = null):
	distance_fallen = player.position.y - player.height_fallen_from
	if verbose:
		print("Distance fallen = ",distance_fallen)
	var impact : float = 0.5
	if from:
		if from.name == "Stomp" && distance_fallen >= 220.0:
			impact += 0.5
	if distance_fallen >= data.distance_before_heavy_landing:
		impact += 0.25 + 0.25 * distance_fallen / data.distance_before_heavy_landing
	if impact < 1.0:
		anim.play("land")
		$"../../SFX/Land2".play()	
	else:
		impact = min(2.0, impact)
		player.heavy_landing_factor = impact
		%Camera2D.apply_shake(impact)
		anim.play("land")
		$"../../SFX/Land3".play()


func Do_Checks():
	if !player.is_on_floor() && !player.is_grounded():
		Transitioned.emit(self,"InAir")
	elif time_in_current_state > player.heavy_landing_factor:
		if player.can_jump():
			Transitioned.emit(self,"Jump")
		elif player.can_dash():
			Transitioned.emit(self,"Dash")
		elif abs(player.x_input) == 1:
			Transitioned.emit(self,"Run")
		elif time_in_current_state > 1.0:
			Transitioned.emit(self,"Idle")
	
	
func Exit():
	player.heavy_landing_factor = 0
	player.height_fallen_from = player.position.y

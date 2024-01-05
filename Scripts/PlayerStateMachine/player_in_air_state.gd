class_name PlayerInAirState
extends PlayerState


var hang_time_active : bool = false
var height_fallen_from : float = 0.0


func Enter():
	if player.velocity.y <= 100 || hang_time_active:
		anim.play("hover")
	else:
		anim.play("fall")
	Flip_Player()
	height_fallen_from = player.position.y
	
	
func Do_Checks():
	if height_fallen_from > player.position.y:
		height_fallen_from = player.position.y
	
	if player.is_on_floor():
		hang_time_active = false
		var distance_fallen = (player.position.y - height_fallen_from)
		if distance_fallen > data.distance_before_medium_landing:
			if distance_fallen > data.distance_before_heavy_landing:
				%Land.heavy_landing = true
			else:
				%Land.heavy_landing = false
			Transitioned.emit(self,"Land")
		elif player.x_input == 0:
			$"../../SFX/Land1".play()
			Transitioned.emit(self,"Idle")
		else: 
			$"../../SFX/Land1".play()
			Transitioned.emit(self,"Run")
	elif player.can_jump():
		player.air_action()
		Transitioned.emit(self,"Jump")
	elif player.can_dash():
		player.air_action()
		Transitioned.emit(self,"Dash")
	elif player.can_grab_wall():
		player.stop_motion()
		Transitioned.emit(self,"WallGrab")
	
		
func Update(_delta):
	if hang_time_active && time_in_current_state > data.hang_time_duration:
		hang_time_active = false
		anim.play("fall", true)


func Physics_Update(delta):
	if hang_time_active:
		player.velocity.y = 0
	else:
		player.velocity.y += data.gravity * delta
		if player.velocity.y > data.max_fall_speed:
			player.velocity.y = data.max_fall_speed
	player.velocity.x = player.x_input * data.in_air_horizontal_speed
	player.move_and_slide()

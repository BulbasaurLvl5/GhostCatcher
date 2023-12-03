class_name PlayerRunState
extends PlayerState


func Enter():
	anim.play("run")
	
	
func Do_Checks():
	if !player.is_grounded:
		$"../../CoyoteTime".start()
		Transitioned.emit(self,"InAir")
	elif Input.is_action_pressed("Jump") && player.jump_button_reset:
		Transitioned.emit(self,"Jump")
	elif Input.is_action_pressed("Dash") && player.dash_button_reset&& player.last_dash_time + data.ground_dash_cooldown < Time.get_unix_time_from_system():
		Transitioned.emit(self,"Dash")
	elif player.x_input == 0:
		Transitioned.emit(self,"Idle")
	elif Input.is_action_pressed("Slow"):
		Transitioned.emit(self,"Walk")
		
		
func Physics_Update(delta):
	var motion = Vector2(data.run_speed * delta * player.x_input, 0) + player.movement_adjustment
	player.movement_adjustment = Vector2.ZERO
	player.move_and_collide(motion)

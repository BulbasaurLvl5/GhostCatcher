class_name PlayerIdleState
extends PlayerState

func Enter():
	anim.play("idle")
	
func Do_Checks():
	if !player.is_grounded && time_in_current_state > 0.1:
		Transitioned.emit(self,"InAir")
	elif Input.is_action_pressed("Jump") && player.can_jump:
		Transitioned.emit(self,"Jump")
	elif abs(player.x_input) == 1:
		Walk_Or_Run(self)
	elif Input.is_action_pressed("Revive") && time_in_current_state > 0.5:
		Transitioned.emit(self,"Die")
	else:
		player.move_and_collide(Vector2.ZERO)

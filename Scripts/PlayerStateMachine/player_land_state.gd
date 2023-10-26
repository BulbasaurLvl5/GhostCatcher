class_name PlayerLandState
extends PlayerState

func Enter():
	anim.play("land")
	
func _animation_finished():
	if Input.is_action_pressed("Jump"):
		Transitioned.emit(self,"Jump")
	elif abs(player.x_input) == 1:
		player_move_states(self)
	else:
		Transitioned.emit(self,"Idle")

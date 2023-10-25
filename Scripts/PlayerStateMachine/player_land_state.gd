class_name PlayerLandState
extends PlayerState

func _enter_state() -> void:
	anim.play("land")
	
func _animation_finished():
	if Input.is_action_pressed("Jump"):
		print("LAND LAND LAND")
		fsm.change_state(jump_state)
	elif player.input_direction.x != 0:
		player_move_states()
	else:
		fsm.change_state(idle_state)

class_name PlayerIdleState
extends PlayerState

func _enter_state() -> void:
	anim.play("idle")
	
func _do_checks(delta):
	if !player.is_grounded:
		
		fsm.change_state(in_air_state)
	elif Input.is_action_pressed("Jump"):
		print("NOW I KNOW WHERE WE'RE GOING INTO THE AIR")
		fsm.change_state(jump_state)
	elif player.input_direction.x != 0:
		player_move_states()
	elif Input.is_action_pressed("Revive"):
		fsm.change_state(die_state)
	else:
		player.move_and_collide(Vector2.ZERO)

class_name PlayerIdleState
extends PlayerState

func _enter_state() -> void:
	anim.play("idle")
	
func _process(delta):
	#dochecks
	if !player.is_on_floor():
		fsm.change_state(in_air_state)
	elif player.input_direction.x != 0:
		fsm.change_state(move_state)
	elif Input.is_action_pressed("Jump"):
		fsm.change_state(jump_state)
	elif Input.is_action_pressed("Revive"):
		fsm.change_state(die_state)

	player.move_and_slide()

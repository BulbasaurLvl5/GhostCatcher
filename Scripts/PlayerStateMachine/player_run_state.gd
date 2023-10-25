class_name PlayerRunState
extends PlayerState


func _enter_state() -> void:
	anim.play("run")
	
func _do_checks(delta):
	if !player.is_grounded:
		fsm.change_state(in_air_state)
	elif Input.is_action_pressed("Jump"):
		print("RUN RUN RUN")
		fsm.change_state(jump_state)
	elif player.input_direction.x == 0:
		fsm.change_state(idle_state)
	elif !Input.is_action_pressed("Run"):
		fsm.change_state(walk_state)
	else:
		var motion = Vector2(player.run_speed * delta * player.input_direction.x, 0)
		player.move_and_collide(motion)

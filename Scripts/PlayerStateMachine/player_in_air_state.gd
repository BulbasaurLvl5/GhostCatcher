class_name PlayerInAirState
extends PlayerState

func _enter_state() -> void:
	anim.play("in_air")
	
func _do_checks(delta):
	if !player.is_grounded:
		fall(delta)
	elif player.input_direction.x == 0:
		fsm.change_state(land_state)
	else:
		player_move_states()

func fall(delta):
	#fall
	player.velocity.y += delta * player.gravity
	if player.input_direction.x != 0:
		player.velocity.x += delta * player.in_air_speed * player.input_direction.x
	var motion = player.velocity * delta
	player.move_and_collide(motion)

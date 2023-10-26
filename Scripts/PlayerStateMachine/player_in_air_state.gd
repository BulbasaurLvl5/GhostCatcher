class_name PlayerInAirState
extends PlayerState

func Enter() -> void:
	anim.play("in_air")
	
func Do_Checks():
	if !player.is_grounded:
		fall()
	elif player.input_direction.x == 0:
		print("Trying to land...")
		Transitioned.emit(self,"Land")
	else:
		player_move_states(self)

func fall():
	#print("Trying to fall...")
	player.velocity.y += player.gravity
	if player.input_direction.x != 0:
		player.velocity.x += player.in_air_speed * player.input_direction.x
	var motion = player.velocity
	player.move_and_collide(motion)

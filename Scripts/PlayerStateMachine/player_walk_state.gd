class_name PlayerWalkState
extends PlayerState

func Enter():
	anim.play("walk")
	
func Do_Checks():
	if !player.is_grounded:
		Transitioned.emit(self,"InAir")
	elif Input.is_action_pressed("Jump"):
		Transitioned.emit(self,"Jump")
	elif player.input_direction.x == 0:
		Transitioned.emit(self,"Idle")
	elif Input.is_action_pressed("Run"):
		Transitioned.emit(self,"Run")
	#else:
		#var motion = Vector2(player.walk_speed * delta * player.input_direction.x, 0)
		#player.move_and_collide(motion)

class_name PlayerLandState
extends PlayerState

func Enter() -> void:
	anim.play("land")
	
func _animation_finished():
	if Input.is_action_pressed("Jump"):
		Transitioned.emit(self,"Jump")
	elif player.input_direction.x != 0:
		player_move_states(self)
	else:
		Transitioned.emit(self,"Idle")

class_name DogBluffChargeState
extends MobState


@export_range(0.0, 1000.0, 1.0, "or_greater", "suffix:pixels/second") var charge_speed : float = 200.0

var time_missing_player : float = 0.0


func Enter(_from):
	ai.is_running_from_dead_end = false
	ai.bark(true)
	if sign(ai.target_path.x) != ai.facing_direction:
		ai.Flip_Mob()
	time_missing_player = 0.0
	#start run anim
	

func Do_Checks(delta):
	if ai.can_see_player():
		time_missing_player = 0.0
	else:
		time_missing_player += delta
	if time_missing_player > 1.0:
		Transitioned.emit(self, "Wander")
	elif abs(ai.target_path.x) < ai.bark_distance_max || !ai.can_step_forward():
		Transitioned.emit(self, "Bark")
		

func Physics_Process(delta):
	ai.velocity.x = charge_speed * ai.facing_direction
	ai.move_and_slide()

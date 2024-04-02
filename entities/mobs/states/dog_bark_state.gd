class_name DogBarkState
extends MobState


func Enter(_from):
	ai.is_running_from_dead_end = false
	ai.velocity = Vector2.ZERO
	if sign(ai.target_path.x) != ai.facing_direction:
		ai.Flip_Mob()
	ai.bark(true)
	#BARK ANIMATION


func Do_Checks(delta):
	if !ai.can_see_player():
		Transitioned.emit(self, "Wander")
	elif abs(ai.target_path.x) > ai.bark_distance_max && ai.can_step_forward():
		Transitioned.emit(self, "BluffCharge")
	elif abs(ai.target_path.x) < ai.bark_distance_min:
		Transitioned.emit(self, "Retreat")
	elif ai.player.facing_direction == sign(ai.target_path.x) && ai.player.velocity.x == 0 && ai.can_step_forward():
		Transitioned.emit(self, "Approach")

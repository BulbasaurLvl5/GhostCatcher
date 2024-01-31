class_name DogApproachState
extends MobState


@export_range(0.0, 60.0, 0.01, "or_greater", "suffix:seconds") var time_to_calm : float = 10.0

var started_approach : bool = false


func Enter(_from):
	ai.is_running_from_dead_end = false
	started_approach = false
	ai.bark(true)
	#BARK ANIMATION
	ai.velocity = Vector2.ZERO	
	

func Do_Checks(_delta):
	if !ai.can_see_player():
		Transitioned.emit(self, "Wander")
	elif ai.player.facing_direction != sign(ai.target_path.x) || ai.player.velocity.x != 0:
		Transitioned.emit(self, "Retreat")
	elif abs(ai.target_path.x) < ai.pet_range:
		Transitioned.emit(self, "GetPets")
	elif time_in_current_state > 2.0 && !started_approach:
		started_approach = true
		#SET WALKING ANIMATION
	elif time_in_current_state > 1.0:
		ai.bark(false)


func Physics_Update(_delta):
	if started_approach:
		var distance = abs(ai.target_path.x) - ai.pet_range
		var time = time_to_calm - time_in_current_state
		ai.velocity.x = ai.facing_direction * distance / time
		ai.move_and_slide()

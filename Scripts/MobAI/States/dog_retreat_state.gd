class_name DogRetreatState
extends MobState


@export_range(0.0, 1000.0, 1.0, "or_greater", "suffix:pixels/second") var retreat_speed : float = 1000.0


func Enter(_from):
	ai.bark(true)
	if sign(ai.target_path.x) == ai.facing_direction && !ai.is_running_from_dead_end:
		ai.Flip_Mob()
	#SET RUN ANIMATION


func Physics_Update(_delta):
	if !ai.can_step_forward():
		ai.Flip_Mob()
		ai.is_running_from_dead_end = true
	ai.velocity.x = retreat_speed * ai.facing_direction
	ai.move_and_slide()
		

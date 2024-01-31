class_name DogWanderState
extends MobState


@export_range(0.0, 1000.0, 1.0, "or_greater", "suffix:pixels/second") var wander_speed : float = 200.0


func Enter(_from):
	ai.is_running_from_dead_end = false
	ai.bark(false)
	if ai.has_been_calmed():
		#set happy walk anim
		pass
	else:
		#set walk anim
		pass


func Do_Checks(_delta):
	if ai.can_see_player():
		if ai.has_been_calmed:
			if abs(ai.target_path.x < ai.pet_range):
				Transitioned.emit(self, "GetPets")
		else:
			if abs(ai.target_path.x < ai.pet_range):
				Transitioned.emit(self, "Growl")
			else:
				Transitioned.emit(self, "Bark") 
	

func Physics_Update(delta):
	ai.velocity.x = wander_speed * ai.facing_direction
	if ai.can_step_forward(ai.velocity.x * delta * 5.0):
		ai.move_and_slide()
	else:
		ai.Flip_Mob()

class_name DogGetPetsState
extends MobState


var is_getting_pets : bool = false


func Enter(_from):
	ai.is_running_from_dead_end = false
	is_getting_pets = false
	ai.velocity = Vector2.ZERO
	ai.bark(false)
	$"../../SFX/Whining".start()
	#RUN GET PETS ANIMATION
	$"Label".global_position = ai.position + Vector2(0.0, -100.0)
	$"Label".visible = true
	

func Do_Checks(_delta):
	if !is_getting_pets && (Input.is_action_pressed("Down1") || Input.is_action_pressed("Down2")):
		is_getting_pets = true
		$"Label".visible = false
		ai.player.pet_dog()
		$"../../SFX/Whining".stop()
		$"../../SFX/Panting".start()
		ai.has_been_calmed = true
	elif abs(ai.target_path.x) > ai.bark_distance_minimum || !ai.can_see_player():
		Transitioned.emit(self, "Wander")
		

func Exit():
	$"Label".visible = false
	$"../../SFX/Whining".stop()
	$"../../SFX/Panting".stop()

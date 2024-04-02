class_name AirChaseState
extends MobState


@export var can_lose_player : bool = true
@export_range(0.0, 500.0, 1.0, "or_greater", "suffix:pixels/second") var chase_speed : float = 300.0


func Update(_delta):
	if ai.current_hesitation <= 0.0:
		if can_lose_player && !ai.can_see_player():
			Transitioned.emit(self, "Patrol")
		elif ai.current_hesitation <= 0.0:
			if ai.facing_direction != sign(ai.target_path.x):
				ai.Flip_Mob()
			Extra_Checks()

func Extra_Checks():
	#Checking for mob-specific moves like Flaming Rage
	pass

	
func Physics_Update(_delta):
	if ai.current_hesitation <= 0.0:
		ai.velocity = Vector2.ZERO.direction_to(ai.target_path) * chase_speed
		ai.move_and_slide()

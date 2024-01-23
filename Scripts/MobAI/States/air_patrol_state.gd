class_name AirPatrolState
extends MobState


@export_range(0.0, 30.0, 0.0, "or_greater", "suffix:seconds  IF APPLICABLE") var time_before_returning : float = 5.0
@export_range(0.0, 500.0, 0.0, "or_greater", "suffix:pixels/second") var patrol_speed : float = 200.0
@export_range(0.0, 30.0, 0.0, "or_greater", "suffix:seconds") var travel_duration : float = 5.0
@export_range(0.0, 10.0, 0.0, "or_greater", "suffix:seconds") var pause_before_travel : float = 1.0
@export_range(0.0, 10.0, 0.0, "or_greater", "suffix:seconds") var pause_after_travel : float = 1.0
@export var patrol_direction : Vector2 = Vector2.RIGHT

var pause_time_remaining : float
var travel_time_remaining : float
var ready_to_turn : bool = false
var current_direction : Vector2


func Enter(_from : MobState):
	pause_time_remaining = pause_before_travel
	travel_time_remaining = travel_duration
	current_direction = Vector2.ZERO.direction_to(patrol_direction)
	if sign(current_direction.x) != ai.facing_direction:
		current_direction.x *= -1
		current_direction.y *= -1
	

func Update(delta):
	if ai.can_see_player():
		Transitioned.emit(self, "Chase")
	elif pause_time_remaining > 0:
		pause_time_remaining -= delta
	else:
		if travel_time_remaining > 0:
			travel_time_remaining -= delta
		else:
			if ready_to_turn:
				if %Return && time_in_current_state > time_before_returning:
					Transitioned.emit(self, "Return")
				else:
					ai.Flip_Mob()
					current_direction.x *= -1
					current_direction.y *= -1
					pause_time_remaining = pause_before_travel
					travel_time_remaining = travel_duration
					ready_to_turn = false
			else:
				pause_time_remaining = pause_after_travel
				ready_to_turn = true
				

func Physics_Update(_delta):
	if travel_time_remaining > 0:
		ai.velocity = current_direction * patrol_speed
		ai.move_and_slide()

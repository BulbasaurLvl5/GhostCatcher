class_name FlamingRageState
extends MobState


@export_range(0.0, 10.0, 0.01, "or_greater", "suffix:seconds") var warning_duration : float = 1.5
@export_range(1.0, 2.0, 0.01, "or_greater", "suffix:X") var scale_increase : float = 1.25 
@export_range(0.0, 2000.0, 1.0, "or_greater", "suffix:pixels/second") var attack_speed : float = 1000.0
@export_range(0.0, 10.0, 0.01, "or_greater", "suffix:seconds") var attack_duration : float = 1.5
@export_range(0.0, 10.0, 0.01, "or_greater", "suffix:seconds") var recovery_duration : float = 1.0
@export_range(0.0, 10.0, 0.01, "or_greater", "suffix:seconds") var attack_cooldown : float = 4.0

@onready var pulse_duration : float = warning_duration / 5.0

var attack_direction : Vector2 = Vector2.ZERO

func Enter(_from : MobState):
	attack_direction = Vector2.ZERO
	var count : int = 3
	var tween_pulse = get_tree().create_tween()
	while count > 0:
		tween_pulse.tween_property(ai, "scale", Vector2(scale_increase, scale_increase), pulse_duration)
		tween_pulse.tween_property(ai, "scale", Vector2.ONE, pulse_duration)
		count -= 1


func Update(_delta):
	if time_in_current_state >= warning_duration:
		if attack_direction == Vector2.ZERO:
			start_attack()
		elif time_in_current_state > warning_duration + attack_duration:
			ai.current_hesitation = recovery_duration
			Transitioned.emit(self, "Chase")

func start_attack():
	attack_direction = ai.global_position.direction_to(ai.player.position)

func Physics_Update(delta):
	ai.move_and_collide(attack_direction * attack_speed * delta)
	
func Exit():
	ai.rage_cooldown_remaining = attack_cooldown
